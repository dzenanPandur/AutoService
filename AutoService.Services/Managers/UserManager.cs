using AutoMapper;
using AutoService.Data.Database;
using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using Humanizer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading;

namespace AutoService.Services.Managers
{
    public class UserManager : IUserManager
    {
        private readonly IPasswordHasher<User> _passwordHasher;
        public readonly AutoServiceContext _context;
        public readonly RoleManager<Role> _identityRoleManager;
        private readonly IRoleManager _roleManager;
        private UserManager<User> _userManager { get; set; }
        public UserManager(AutoServiceContext context, IPasswordHasher<User> passwordHasher, RoleManager<Role> identityRoleManager, UserManager<User> userManager, IRoleManager roleManager)
        {
            _passwordHasher = passwordHasher;
            _context = context;
            _identityRoleManager = identityRoleManager;
            _userManager = userManager;
            _roleManager = roleManager;
        }
        public async Task<UserDto> GetByUsernameOrEmail(string? username, string? email)
        {
            if (string.IsNullOrEmpty(username) && string.IsNullOrEmpty(email))
            {
                return null;
            }

            string? normalizedUsername = !string.IsNullOrEmpty(username) ? username.ToUpperInvariant() : null;

            User user = await _context.Users
                .FirstOrDefaultAsync(x =>
                    (normalizedUsername != null && x.NormalizedUserName == normalizedUsername) ||
                    (!string.IsNullOrEmpty(email) && x.NormalizedEmail == email));

            if (user == null)
            {
                return null;
            }

            RoleDto roleDto = await _roleManager.GetRoleById(user.RoleId);
            UserDto userDto = new UserDto(user)
            {
                Role = roleDto
            };

            return userDto;
        }

        public async Task<UserDto> GetByUsername(string username)
        {
            username = username.ToUpperInvariant();
            User user = await _context
                .Users
                .FirstOrDefaultAsync(x => x.NormalizedUserName == username);

            UserDto userDto = new UserDto(user);

            RoleDto roleDto = await _roleManager.GetRoleById(user.RoleId);
            userDto.Role = roleDto;

            return userDto;
        }

        //public async Task<List<User>> GetAllUsers()
        //{
        //    List<User> users = await _context.Users.ToListAsync();
        //    return users;

        //}
        public async Task<List<UserDto>> GetAllUsers()
        {
            List<User> users = await _context.Users.ToListAsync();

            if (users == null || users.Count == 0)
            {
                return null;
            }

            var userDtos = new List<UserDto>();

            foreach (var user in users)
            {
                RoleDto roleDto = await _roleManager.GetRoleById(user.RoleId);

                UserDto userDto = new UserDto(user);
                userDto.Role = roleDto;

                userDtos.Add(userDto);
            }

            return userDtos;
        }
    

        public async Task<int> CreateUser(UserDto dto)
        {
            var user = new User(dto);
            _context.ChangeTracker.Clear();

            user.Id = Guid.NewGuid();
            user.SecurityStamp = Guid.NewGuid().ToString();
            user.NormalizedUserName = user.UserName.ToUpperInvariant();
            user.NormalizedEmail = user.Email.ToUpperInvariant();
            user.ConcurrencyStamp = Guid.NewGuid().ToString();
            user.CreatedDate = DateTime.Now;
            user.ModifiedDate = DateTime.Now;
            user.PasswordHash = _passwordHasher.HashPassword(user, dto.Password);

            await _userManager.CreateAsync(user, dto.Password);

            _context.Users.Add(user);
            _context.UserRoles.Add(new IdentityUserRole<Guid>
            {
                UserId = user.Id,
                RoleId = user.RoleId
            });
            

            return await _context.SaveChangesAsync();
        }

    }
}
