﻿using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.UserData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.UserData;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AppointmentController : ControllerBase
    {
        private readonly IAppointmentManager _appointmentManager;
        public AppointmentController(IAppointmentManager appointmentManager) 
        {
            _appointmentManager = appointmentManager;
        }

        [HttpGet("GetAllAppointments")]
        public async Task<IActionResult> GetAllAppointments() 
        {

            IEnumerable<AppointmentDto> appointments = await _appointmentManager.GetAllAppointments();

            if (appointments == null || appointments.Count() == 0)
            {
                return NotFound("No appointments found.");
            }

            return Ok(appointments);
            //List<UserViewModel> userViewModels = new List<UserViewModel>();

            //foreach (UserDto userDto in users)
            //{
            //    UserViewModel userViewModel = new UserViewModel(userDto);
            //    userViewModels.Add(userViewModel);
            //}

            //return Ok(userViewModels);
        }

        [HttpGet("GetAppointmentById")]

        public async Task<IActionResult> GetAppointment(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var appointment = await _appointmentManager.GetAppointment(id);

            if (appointment == null)
            {
                return NotFound("Appointment not found.");
            }

            return Ok(appointment);
        }

        [HttpPost("CreateAppointment")]

        public async Task<IActionResult> CreateAppointment(AppointmentDto dto)
        {
            int message = await _appointmentManager.CreateAppointment(dto);
            if (message > 0)
            {
                return Ok("Appointment created successfully.");
            }
            else
            {
                return BadRequest("Failed to create Appointment.");
            }
        }

        [HttpPut("UpdateAppointment")]

        public async Task<IActionResult> UpdateAppointment(AppointmentDto dto)
        {
            AppointmentDto appointment = await _appointmentManager.UpdateAppointment(dto);

            if (appointment == null)
            {
                return NotFound("Appointment not found.");
            }

            return Ok(appointment);
        }

        [HttpDelete("DeleteAppointment")]

        public async Task<IActionResult> DeleteAppointment(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var appointment = await _appointmentManager.GetAppointment(id);

            if (appointment == null)
            {
                return NotFound("Appointment not found.");
            }

            await _appointmentManager.DeleteAppointment(id);

            return Ok("Successfully deleted appointment");
        }
    }
}
