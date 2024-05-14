using AutoService.Data.Database;
using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

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

            if (user == null)
                return null;

            UserDto userDto = new UserDto(user);

            RoleDto roleDto = await _roleManager.GetRoleById(user.RoleId);
            userDto.Role = roleDto;

            return userDto;
        }

        public async Task<UserDto> GetUserById(Guid id)
        {
            UserDto user = await _context.Users
                .Where(a => a.Id == id)
                .Select(a => new UserDto(a))
                .FirstOrDefaultAsync();
            return user;
        }

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
            user.RoleId = dto.RoleId;

            await _userManager.CreateAsync(user, dto.Password);

            _context.Users.Add(user);


            return await _context.SaveChangesAsync();
        }

        public async Task<User> UpdateUser(UserDto dto)
        {
            var user = await _context.Users.Where(x => x.Id == dto.Id).FirstOrDefaultAsync();

            if (user == null)
            {
                throw new Exception("Not found");
            }


            _context.ChangeTracker.Clear();

            user.UserName = dto.UserName;
            user.Email = dto.Email;
            user.FirstName = dto.FirstName;
            user.LastName = dto.LastName;
            user.PhoneNumber = dto.PhoneNumber;
            user.Address = dto.Address;
            user.City = dto.City;
            user.PostalCode = dto.PostalCode;
            user.Active = dto.Active;
            user.Gender = dto.Gender;

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<User> ChangeActiveStatusUser(Guid id, bool active)
        {
            var user = await _context.Users.Where(x => x.Id == id).FirstOrDefaultAsync();

            if (user == null)
            {
                throw new Exception("Not found");
            }
            _context.ChangeTracker.Clear();
            user.Active = active;

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return user;
        }
        public async Task<int> DeleteUser(Guid id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return 0;
            }

            _context.Users.Remove(user);
            return await _context.SaveChangesAsync();
        }
    }
}
