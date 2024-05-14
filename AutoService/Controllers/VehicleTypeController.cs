using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class VehicleTypeController : ControllerBase
    {
        private readonly IVehicleTypeManager _vehicleTypeManager;
        public VehicleTypeController(IVehicleTypeManager vehicleTypeManager)
        {
            _vehicleTypeManager = vehicleTypeManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllVehicleTypes()
        {

            IEnumerable<VehicleTypeDto> vehicleTypes = await _vehicleTypeManager.GetAllVehicleTypes();

            if (vehicleTypes == null || vehicleTypes.Count() == 0)
            {
                return NotFound("No VehicleTypes found.");
            }

            return Ok(vehicleTypes);
        }

        [HttpGet("GetById")]
        [Authorize]

        public async Task<IActionResult> GetVehicleType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var VehicleType = await _vehicleTypeManager.GetVehicleType(id);

            if (VehicleType == null)
            {
                return NotFound("VehicleType not found.");
            }

            return Ok(VehicleType);
        }

        [HttpPost("Create")]
        [Authorize]
        public async Task<IActionResult> CreateVehicleType(VehicleTypeDto dto)
        {
            int message = await _vehicleTypeManager.CreateVehicleType(dto);
            if (message > 0)
            {
                return Ok("VehicleType created successfully.");
            }
            else
            {
                return BadRequest("Failed to create VehicleType.");
            }
        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateVehicleType(VehicleTypeDto dto)
        {
            VehicleTypeDto vehicleType = await _vehicleTypeManager.UpdateVehicleType(dto);

            if (vehicleType == null)
            {
                return NotFound("VehicleType not found.");
            }

            return Ok(vehicleType);
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteVehicleType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var VehicleType = await _vehicleTypeManager.GetVehicleType(id);

            if (VehicleType == null)
            {
                return NotFound("VehicleType not found.");
            }

            await _vehicleTypeManager.DeleteVehicleType(id);

            return Ok("Successfully deleted VehicleType");
        }
    }
}
