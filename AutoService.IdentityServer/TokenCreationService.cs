using IdentityServer4.Models;
using IdentityServer4.Services;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace AutoService.IdentityServer
{
    public class TokenCreationService : ITokenCreationService
    {
        public TokenCreationService()
        {

        }

        public Task<string> CreateTokenAsync(Token token)
        {
            var jwtSecurityTokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Audience = token.Audiences.FirstOrDefault(),
                IssuedAt = token.CreationTime,
                Issuer = token.Issuer,
                Claims = token.Claims.ToDictionary(x=>x.Type,x=> (object)x.Value),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes("deb5059b-d97a-46d8-97ea-581cad4a4ac1")), SecurityAlgorithms.HmacSha512Signature)
            };
            var tokenjwt = jwtSecurityTokenHandler.CreateJwtSecurityToken(tokenDescriptor);

            return Task.FromResult(jwtSecurityTokenHandler.WriteToken(tokenjwt));
        }
    }
}
