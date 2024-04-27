using AutoService.Data.DTO.ServiceData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.ServiceData;
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
        private readonly IVehicleManager _vehicleManager;
        private readonly IClientManager _clientManager;
        public RequestController(IRequestManager requestManager, IAppointmentManager appointmentManager, IVehicleManager vehicleManager, IClientManager clientManager)
        {
            _requestManager = requestManager;
            _appointmentManager = appointmentManager;
            _vehicleManager = vehicleManager;
            _clientManager = clientManager;
        }

        [HttpGet("GetAll")]
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
                var vehicle = await _vehicleManager.GetVehicle((int)requestDto.VehicleId);
                var client = await _clientManager.GetClient(requestDto.ClientId);
                RequestViewModel requestViewModel = new RequestViewModel(requestDto);
                requestViewModel.VehicleName = vehicle.Make + " " + vehicle.Model;
                requestViewModel.ClientName = client.FirstName + " " + client.LastName;
                requestViewModel.VehicleId = requestDto.VehicleId;
                requestViewModels.Add(requestViewModel);
            }

            return Ok(requestViewModels);
        }

        [HttpGet("GetById")]

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

            return Ok(request);
        }

        [HttpPost("Create")]

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

        [HttpPut("Update")]

        public async Task<IActionResult> UpdateRequest(RequestDto dto)
        {
            RequestDto request = await _requestManager.UpdateRequest(dto);

            if (request == null)
            {
                return NotFound("Request not found.");
            }

            return Ok(request);
        }

        [HttpDelete("Delete")]

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
