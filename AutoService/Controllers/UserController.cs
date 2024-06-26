﻿using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.UserData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserManager _manager;

        private UserManager<User> _userManager;

        public UserController(IUserManager manager, UserManager<User> userManager)
        {
            _manager = manager;
            _userManager = userManager;
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
        [Authorize]
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
        [Authorize]
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

            if (string.IsNullOrEmpty(userDto.FirstName) ||
               string.IsNullOrEmpty(userDto.LastName) ||
               string.IsNullOrEmpty(userDto.Gender.ToString()) ||
               string.IsNullOrEmpty(userDto.City) ||
               string.IsNullOrEmpty(userDto.PostalCode?.ToString()) ||
               string.IsNullOrEmpty(userDto.Address) ||
               string.IsNullOrEmpty(userDto.BirthDate.ToString()) ||
               string.IsNullOrEmpty(userDto.UserName) ||
               string.IsNullOrEmpty(userDto.Email) ||
               string.IsNullOrEmpty(userDto.PhoneNumber) ||
               string.IsNullOrEmpty(userDto.Password) ||
               string.IsNullOrEmpty(userDto.PasswordConfirm))
            {
                return BadRequest("All fields must be filled!");

            }
            if (userDto.UserName.Length < 5)
                return BadRequest("Username minimum length is 5 characters!");

            if (userDto.Password.Length < 6)
                return BadRequest("Password minimum length is 6 characters!");

            if (_userManager.FindByNameAsync(userDto.UserName).Result != null)
                return BadRequest("Username already taken!");

            if (_userManager.FindByEmailAsync(userDto.Email).Result != null)
                return BadRequest("Account with that email already exists!");

            if (userDto.Password != userDto.PasswordConfirm)
                return BadRequest("Password and password confirm do not match!");


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
        [Authorize]
        public async Task<IActionResult> UpdateUser(UserDto userDto)
        {

            if (string.IsNullOrEmpty(userDto.FirstName) ||
               string.IsNullOrEmpty(userDto.LastName) ||
               string.IsNullOrEmpty(userDto.City) ||
               string.IsNullOrEmpty(userDto.PostalCode?.ToString()) ||
               string.IsNullOrEmpty(userDto.Address) ||
               string.IsNullOrEmpty(userDto.UserName) ||
               string.IsNullOrEmpty(userDto.Email) ||
               string.IsNullOrEmpty(userDto.PhoneNumber))
            {
                return BadRequest("All fields must be filled!");

            }

            var _user = _manager.GetUserById(userDto.Id);

            if (userDto.UserName.Length < 5)
                return BadRequest("Username minimum length is 5 characters!");

            if (userDto.UserName != _user.Result.UserName)
            {
                if (_userManager.FindByNameAsync(userDto.UserName).Result != null)
                    return BadRequest("Username already taken!");
            }
            if (userDto.Email != _user.Result.Email)
            {
                if (_userManager.FindByEmailAsync(userDto.Email).Result != null)
                    return BadRequest("Account with that email already exists!");
            }

            User user = await _manager.UpdateUser(userDto);

            if (user == null)
                return NotFound("User not found.");


            return Ok(user);
        }

        [HttpPut("ChangeActiveStatusUser")]
        [Authorize]
        public async Task<IActionResult> ChangeActiveStatusUser(Guid id, bool active)
        {


            User user = await _manager.ChangeActiveStatusUser(id, active);

            if (user == null)
                return NotFound("User not found.");


            return Ok("Succesfully updated status.");
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteUser(Guid id)
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
