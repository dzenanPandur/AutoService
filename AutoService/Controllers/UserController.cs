using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.UserData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserManager _manager;

        public UserController(IUserManager manager)
        {
            _manager = manager;
        }

        [HttpGet("GetByUsernameOrEmail")]
        [AllowAnonymous]
        public async Task<IActionResult> GetByUsernameOrEmail(string? username, string? email)
        {
            if (string.IsNullOrEmpty(username) && string.IsNullOrEmpty(email))
            {
                return BadRequest("Username or email must be provided.");
            }

            UserDto user = await _manager.GetByUsernameOrEmail(username, email);
            if (user == null)
            {
                return NotFound("User not found.");
            }

            UserViewModel userViewModel = new UserViewModel(user);

            return Ok(userViewModel);
        }

        [HttpGet("GetByUsername")]
        //[AllowAnonymous]
        [Authorize]
        public async Task<IActionResult> GetByUsername(string username)
        {
            if (string.IsNullOrEmpty(username))
            {
                return BadRequest("Username must be provided.");
            }

            UserDto user = await _manager.GetByUsername(username);
            if (user == null)
            {
                return NotFound("User not found.");
            }

            UserViewModel userViewModel = new UserViewModel(user);

            return Ok(userViewModel);
        }

        [HttpGet("GetById")]

        public async Task<IActionResult> GetUserById(Guid id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var user = await _manager.GetUserById(id);

            if (user == null)
            {
                return NotFound("User not found.");
            }

            return Ok(user);
        }

        [HttpGet("GetAll")]
        //[Authorize]
        public async Task<IActionResult> GetAllUsers()
        {
            List<UserDto> users = await _manager.GetAllUsers();

            if (users == null || users.Count == 0)
            {
                return NotFound("No users found.");
            }

            List<UserViewModel> userViewModels = new List<UserViewModel>();

            foreach (UserDto userDto in users)
            {
                UserViewModel userViewModel = new UserViewModel(userDto);
                userViewModels.Add(userViewModel);
            }

            return Ok(userViewModels);
        }

        [HttpGet("GetAllEmployees")]
        //[Authorize]
        public async Task<IActionResult> GetEmployees()
        {
            List<UserDto> users = await _manager.GetAllUsers();

            if (users == null || users.Count == 0)
            {
                return NotFound("No employees found.");
            }

            List<UserDto> employeeUsers = users.Where(user => user.Role.Name == "Employee").ToList();

            if (employeeUsers.Count == 0)
            {
                return NotFound("No employees found.");
            }

            List<UserViewModel> employeeViewModels = new List<UserViewModel>();

            foreach (UserDto userDto in employeeUsers)
            {
                UserViewModel userViewModel = new UserViewModel(userDto);
                employeeViewModels.Add(userViewModel);
            }

            return Ok(employeeViewModels);
        }


        [HttpPost("Create")]
        [AllowAnonymous]
        public async Task<IActionResult> CreateUser([FromBody] UserDto userDto)
        {
            int message = await _manager.CreateUser(userDto);
            if (message > 0)
            {
                return Ok("User created successfully.");
            }
            else
            {
                return BadRequest("Failed to create user.");
            }
        }
        [HttpPut("Update")]
        //[Authorize]
        public async Task<IActionResult> UpdateUser(UserDto userDto)
        {
            User user = await _manager.UpdateUser(userDto);

            if (user == null)
            {
                return NotFound("User not found.");
            }

            return Ok(user);
        }

        [HttpDelete("Delete")]

        public async Task<IActionResult> DeleteService(Guid id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var user = await _manager.GetUserById(id);

            if (user == null)
            {
                return NotFound("User not found.");
            }

            await _manager.DeleteUser(id);

            return Ok("Successfully deleted user.");
        }
    }

}
