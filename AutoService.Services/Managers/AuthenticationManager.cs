using AutoService.Data.Database;
using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.AuthData;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Authentication;
using System.Security.Claims;
using System.Text;

namespace AutoService.Services.Managers
{
    public class AuthenticationManager : IAuthenticationManager
    {
        private readonly IUserManager _userManager;
        private readonly IPasswordHasher<User> passwordHasher;
        private readonly IConfiguration configuration;
        protected readonly AutoServiceContext context;

        public AuthenticationManager
        (
            IUserManager userManager,
            IPasswordHasher<User> passwordHasher,
            IConfiguration configuration,
            AutoServiceContext context)
        {
            _userManager = userManager;
            this.passwordHasher = passwordHasher;
            this.configuration = configuration;
            this.context = context;
        }

        public async Task<AuthenticationResponse?> Authenticate(AuthenticationRequest request)
        {

            UserDto userDto = await _userManager.GetByUsername(request.Username);

            if (userDto == null)
            {
                throw new AuthenticationException("Username or password is wrong.");
            }

            User user = new User(userDto);

            if (passwordHasher.VerifyHashedPassword(user, userDto.Password, request.Password) != PasswordVerificationResult.Success)
            {
                throw new AuthenticationException("Username or password is wrong.");
            }

            var jwtSecurityTokenHandler = new JwtSecurityTokenHandler();

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Audience = configuration["Jwt:Audience"],
                IssuedAt = DateTime.Now,
                Issuer = configuration["Jwt:Issuer"],
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:Secret"])), SecurityAlgorithms.HmacSha512Signature)
            };



            tokenDescriptor.Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.RoleId.ToString())
            });


            var token = jwtSecurityTokenHandler.CreateJwtSecurityToken(tokenDescriptor);

            return new AuthenticationResponse
            {
                Token = jwtSecurityTokenHandler.WriteToken(token),
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = user.Role.Name,
                PhoneNumber = user.PhoneNumber,
                Email = user.Email,
                Username = user.UserName,
                UserId = user.Id,
                Gender = user.Gender,
                isActive = user.Active,

            };
        }
    }
}
