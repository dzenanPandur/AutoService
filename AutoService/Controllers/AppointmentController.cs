using AutoService.Data.DTO.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
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

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllAppointments()
        {

            IEnumerable<AppointmentDto> appointments = await _appointmentManager.GetAllAppointments();

            if (appointments == null || appointments.Count() == 0)
            {
                return NotFound("No appointments found.");
            }

            return Ok(appointments);

        }

        [HttpGet("GetById")]
        [Authorize]
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

        [HttpPost("Create")]
        [Authorize]
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

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateAppointment(AppointmentDto dto)
        {
            AppointmentDto appointment = await _appointmentManager.UpdateAppointment(dto);

            if (appointment == null)
            {
                return NotFound("Appointment not found.");
            }

            return Ok(appointment);
        }

        [HttpDelete("Delete")]
        [Authorize]
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
