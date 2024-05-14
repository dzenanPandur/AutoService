using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.VehicleData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VehicleController : ControllerBase
    {
        private readonly IVehicleManager _vehicleManager;
        private readonly IClientManager _clientManager;
        public VehicleController(IVehicleManager vehicleManager, IClientManager clientManager)
        {
            _vehicleManager = vehicleManager;
            _clientManager = clientManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllVehicles()
        {

            IEnumerable<VehicleDto> vehicles = await _vehicleManager.GetAllVehicles();

            if (vehicles == null || vehicles.Count() == 0)
            {
                return NotFound("No Vehicles found.");
            }


            List<VehicleViewModel> vehicleViewModels = new List<VehicleViewModel>();

            foreach (VehicleDto vehicleDto in vehicles)
            {
                var client = await _clientManager.GetClient(vehicleDto.ClientId);
                VehicleViewModel vehicleViewModel = new VehicleViewModel(vehicleDto);
                vehicleViewModel.ClientName = client.FirstName + " " + client.LastName;
                vehicleViewModels.Add(vehicleViewModel);

            }

            return Ok(vehicleViewModels);
        }

        [Authorize]
        [HttpGet("GetById")]
        public async Task<IActionResult> GetVehicle(int id)
        {
            if (id <= 0)
            {
                return BadRequest("Id must be a positive integer.");
            }

            var vehicle = await _vehicleManager.GetVehicle(id);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            var client = await _clientManager.GetClient(vehicle.ClientId);

            VehicleViewModel vehicleViewModel = new VehicleViewModel(vehicle);
            vehicleViewModel.ClientName = client.FirstName + " " + client.LastName;

            return Ok(vehicleViewModel);
        }

        [HttpPost("Create")]
        [Authorize]
        public async Task<IActionResult> CreateVehicle(VehicleDto dto)
        {
            try
            {
                dto.ClientId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));
                var vehicles = await _clientManager.GetAllVehiclesByClient(dto.ClientId);
                if (vehicles.Where(x => x.isArchived == false).Count() >= 3)
                    return BadRequest("Maximum of 3 vehicles per user!");

                dto.Id = await _vehicleManager.CreateVehicle(dto);

                return Ok("Vehicle created successfully.");
            }
            catch (Exception e)
            {
                return Problem(e.InnerException.ToString());
            }

        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateVehicle(VehicleDto dto)
        {
            VehicleDto vehicle = await _vehicleManager.UpdateVehicle(dto);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            return Ok(vehicle);
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteVehicle(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var vehicle = await _vehicleManager.GetVehicle(id);

            if (vehicle.Status != Data.Enums.Status.Idle
                || vehicle.Status != Data.Enums.Status.Rejected
                || vehicle.Status != Data.Enums.Status.Canceled
                || vehicle.Status != Data.Enums.Status.Completed)
            {
                return BadRequest("Cannot delete vehicle while request is in progress!");
            }

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            await _vehicleManager.DeleteVehicle(id);

            return Ok("Successfully deleted Vehicle");
        }
    }
}
