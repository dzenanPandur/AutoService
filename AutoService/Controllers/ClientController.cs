using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.UserData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.ServiceData;
using AutoService.ViewModels.VehicleData;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ClientController : ControllerBase
    {
        private readonly IClientManager _clientManager;
        private readonly IVehicleManager _vehicleManager;
        public ClientController(IClientManager clientManager, IVehicleManager vehicleManager)
        {
            _clientManager = clientManager;
            _vehicleManager = vehicleManager;
        }

        [HttpGet("GetById")]
        public async Task<IActionResult> GetClient(Guid id)
        {

            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var client = await _clientManager.GetClient(id);

            if (client == null)
            {
                return NotFound("Client not found.");
            }

            return Ok(client);

        }

        [HttpGet("GetAll")]
        public async Task<IActionResult> GetAllClients()
        {
            IEnumerable<UserDto> clients = await _clientManager.GetAllClients();

            if (clients == null || clients.Count() == 0)
            {
                return NotFound("No Clients found.");
            }

            return Ok(clients);
            //List<RequestViewModel> requestViewModels = new List<RequestViewModel>();

            //foreach (RequestDto requestDto in requests)
            //{
            //    RequestViewModel requestViewModel = new RequestViewModel(requestDto);
            //    requestViewModels.Add(requestViewModel);
            //}

            //return Ok(requestViewModels);
        }

        [HttpGet("GetAllRequestsByClient")]
        public async Task<IActionResult> GetAllRequestsByClient(Guid id)
        {

            IEnumerable<RequestDto> requests = await _clientManager.GetAllRequestsByClient(id);

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

        [HttpGet("GetAllAppointmentsByClient")]
        public async Task<IActionResult> GetAllAppointmentsByClient(Guid id)
        {

            IEnumerable<AppointmentDto> appointments = await _clientManager.GetAllAppointmentsByClient(id);

            if (appointments == null || appointments.Count() == 0)
            {
                return NotFound("No appointments found.");
            }

            return Ok(appointments);
        }

        [HttpGet("GetAllVehiclesByClient")]
        public async Task<IActionResult> GetAllVehiclesByClient(Guid id)
        {

            IEnumerable<VehicleDto> vehicles = await _clientManager.GetAllVehiclesByClient(id);

            if (vehicles == null || vehicles.Count() == 0)
            {
                return NotFound("No Vehicles found.");
            }

            //return Ok(vehicles);

            List<VehicleViewModel> vehicleViewModels = new List<VehicleViewModel>();

            foreach (VehicleDto vehicleDto in vehicles)
            {

                VehicleViewModel vehicleViewModel = new VehicleViewModel(vehicleDto);
                vehicleViewModels.Add(vehicleViewModel);

            }

            return Ok(vehicleViewModels);
        }
    }
}
