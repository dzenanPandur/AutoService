using AutoService.Data.DTO.ServiceData;
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
        public VehicleController(IVehicleManager vehicleManager)
        {
            _vehicleManager = vehicleManager;
        }

        [HttpGet("GetAllVehicles")]
        public async Task<IActionResult> GetAllVehicles()
        {

            IEnumerable<VehicleDto> vehicles = await _vehicleManager.GetAllVehicles();

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

        [HttpGet("GetVehicleById")]

        public async Task<IActionResult> GetVehicle(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var vehicle = await _vehicleManager.GetVehicle(id);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            return Ok(vehicle);
        }

        [HttpPost("CreateVehicle")]
        [Authorize]
        public async Task<IActionResult> CreateVehicle(VehicleDto dto)
        {
            try
            {
                dto.ClientId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));
                dto.Id = await _vehicleManager.CreateVehicle(dto);

                return Ok("Vehicle created successfully.");
            }
            catch (Exception e) 
            {
                return Problem(e.InnerException.ToString());
            }
            //int message = await _vehicleManager.CreateVehicle(dto);
            //if (message > 0)
            //{
            //    return Ok("Vehicle created successfully.");
            //}
            //else
            //{
            //    return BadRequest("Failed to create Vehicle.");
            //}
        }

        [HttpPut("UpdateVehicle")]

        public async Task<IActionResult> UpdateVehicle(VehicleDto dto)
        {
            VehicleDto vehicle = await _vehicleManager.UpdateVehicle(dto);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            return Ok(vehicle);
        }

        [HttpDelete("DeleteVehicle")]

        public async Task<IActionResult> DeleteVehicle(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var vehicle = await _vehicleManager.GetVehicle(id);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            await _vehicleManager.DeleteVehicle(id);

            return Ok("Successfully deleted Vehicle");
        }
    }
}
