using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using AutoService.Services.Managers;
using AutoService.ViewModels.ServiceData;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RequestController : ControllerBase
    {
        private readonly IRequestManager _requestManager;
        private readonly IAppointmentManager _appointmentManager;
        public RequestController(IRequestManager requestManager, IAppointmentManager appointmentManager)
        {
            _requestManager = requestManager;
            _appointmentManager = appointmentManager;
        }

        [HttpGet("GetAllRequests")]
        public async Task<IActionResult> GetAllRequests()
        {

            IEnumerable<RequestDto> requests = await _requestManager.GetAllRequests();

            if (requests == null || requests.Count() == 0)
            {
                return NotFound("No Requests found.");
            }

            //return Ok(requests);
            List<RequestViewModel> requestViewModels = new List<RequestViewModel>();

            foreach (RequestDto requestDto in requests)
            {
                RequestViewModel requestViewModel = new RequestViewModel(requestDto);
                requestViewModels.Add(requestViewModel);
            }

            return Ok(requestViewModels);
        }

        [HttpGet("GetRequestById")]

        public async Task<IActionResult> GetRequest(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var request = await _requestManager.GetRequest(id);

            if (request == null)
            {
                return NotFound("Request not found.");
            }

            return Ok(Request);
        }

        [HttpPost("CreateRequest")]

        public async Task<IActionResult> CreateRequest(RequestDto dto)
        {
            try
            {
                dto.ClientId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

                dto.Id = await _requestManager.CreateRequest(dto);
                dto.Appointment.ClientId = dto.ClientId;
                dto.Appointment.RequestId = dto.Id;

                dto.AppointmentId = await _appointmentManager.CreateAppointment(dto.Appointment);
                await _requestManager.UpdateRequest(dto);

                return Ok("Request created successfully.");
            }
            catch (Exception e)
            {
                return Problem(e.InnerException.ToString());
            }
        }

        [HttpPut("UpdateRequest")]

        public async Task<IActionResult> UpdateRequest(RequestDto dto)
        {
            RequestDto request = await _requestManager.UpdateRequest(dto);

            if (request == null)
            {
                return NotFound("Request not found.");
            }

            return Ok(request);
        }

        [HttpDelete("DeleteRequest")]

        public async Task<IActionResult> DeleteRequest(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var request = await _requestManager.GetRequest(id);

            if (request == null)
            {
                return NotFound("Request not found.");
            }

            await _requestManager.DeleteRequest(id);

            return Ok("Successfully deleted Request");
        }
    }
}
