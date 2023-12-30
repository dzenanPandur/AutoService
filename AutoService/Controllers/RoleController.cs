using AutoService.Data.DTO.UserData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RoleController : ControllerBase
    {
        private readonly IRoleManager _manager;

        public RoleController(IRoleManager manager)
        {
            _manager = manager;
        }

        [HttpGet("GetRoleById")]
        //[AllowAnonymous]
        //[Authorize]
        public async Task<IActionResult> GetRoleById(Guid id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var role = await _manager.GetRoleById(id);

            if (role == null)
            {
                return NotFound("Role not found.");
            }

            return Ok(role);
        }

        [HttpGet("GetRoleByName")]
        //[AllowAnonymous]
        //[Authorize]
        public async Task<IActionResult> GetRoleByName(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return BadRequest("Name must be provided.");
            }

            var role = await _manager.GetRoleByName(name);

            if (role == null)
            {
                return NotFound("Role not found.");
            }

            return Ok(role);
        }

    }
}
