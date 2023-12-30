using AutoService.Data.Database;
using AutoService.Data.Entities.UserData;
using IdentityServer4;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AutoService.IdentityServer.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AccountController : ControllerBase
    {
        private readonly SignInManager<User> _signInManager;
        private readonly UserManager<User> _userManager;
        private readonly IdentityServerTools _tools;
        private readonly RoleManager<Role> _roleManager;
        private readonly AutoServiceContext context;

        public AccountController
        (
            SignInManager<User> signInManager,
            UserManager<User> userManager,
            IdentityServerTools tools,
            RoleManager<Role> roleManager,
            AutoServiceContext context
        )
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _tools = tools;
            _roleManager = roleManager;
            this.context = context;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(AuthRequest request)
        {
            var response = new AuthResponse();
            var result = await _signInManager.PasswordSignInAsync(request.Username, request.Password, false, lockoutOnFailure: true);

            response.Result = result.Succeeded;

            if (result.Succeeded)
            {
                var user = await _userManager.FindByNameAsync(request.Username);
                var client = context.Clients.FirstOrDefault(x => x.Id == user.Id);
                var roles = await _userManager.GetRolesAsync(user);
                var claims = new List<Claim> { 
                    new Claim("nameid", user.Id.ToString()),
                    new Claim(ClaimTypes.Name, request.Username),
                    //new Claim("ClientId", client?.Id.ToString())
                };

                foreach (var role in roles) claims.Add(new Claim("role", role));

                response.Token = await _tools.IssueClientJwtAsync("client", 3600, scopes: new[] { "api1" }, audiences: new[] { "api1" }, additionalClaims: claims);

                return Ok(response);
            }
            return BadRequest("Log in failed");
        }
    }
}
