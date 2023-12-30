using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using AutoService.Data.Database;
using AutoService.Data.Entities.ClientData;
using AutoService.Data.DTO.UserData;

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
            _userManager= userManager;
            this.passwordHasher = passwordHasher;
            this.configuration = configuration;
            this.context = context;
        }

        public async Task<AuthenticationResponse?> Authenticate(AuthenticationRequest request)
        {
            UserDto userDto = await _userManager.GetByUsername(request.Username);
            User user = new User(userDto);

            if (user == null)
            {
                return null;
            }

            if (passwordHasher.VerifyHashedPassword(user, user.PasswordHash!, request.Password) != PasswordVerificationResult.Success)
            {
                return null;
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

            

            // Add claims without using 'Action' type
            tokenDescriptor.Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.RoleId.ToString())
            });


            var token = jwtSecurityTokenHandler.CreateJwtSecurityToken(tokenDescriptor);

            return new AuthenticationResponse
            {
                Token = jwtSecurityTokenHandler.WriteToken(token)
            };
        }
    }
    }
