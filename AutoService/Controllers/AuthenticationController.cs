using AutoService.Services.Interfaces;
using AutoService.ViewModels.AuthData;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AuthenticationController : ControllerBase
    {
        private readonly IAuthenticationManager _authenticationManager;

        public AuthenticationController(IAuthenticationManager authenticationManager)
        {
            _authenticationManager = authenticationManager;
        }

        [HttpPost("[action]")]
        public async Task<IActionResult> Login(AuthenticationRequest authenticationRequest)
        {
            var result = await _authenticationManager.Authenticate(authenticationRequest);

            if (result == null)
            {
                return BadRequest("Invalid");
            }
            return Ok(result);
        }
    }
}
