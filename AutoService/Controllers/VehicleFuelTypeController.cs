﻿using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class VehicleFuelTypeController : ControllerBase
    {
        private readonly IVehicleFuelTypeManager _vehicleFuelTypeManager;
        public VehicleFuelTypeController(IVehicleFuelTypeManager vehicleFuelTypeManager)
        {
            _vehicleFuelTypeManager = vehicleFuelTypeManager;
        }

        [HttpGet("GetAllVehicleFuelTypes")]
        public async Task<IActionResult> GetAllVehicleFuelTypes()
        {

            IEnumerable<VehicleFuelTypeDto> vehicleFuelTypes = await _vehicleFuelTypeManager.GetAllVehicleFuelTypes();

            if (vehicleFuelTypes == null || vehicleFuelTypes.Count() == 0)
            {
                return NotFound("No VehicleFuelTypes found.");
            }

            return Ok(vehicleFuelTypes);
            //List<UserViewModel> userViewModels = new List<UserViewModel>();

            //foreach (UserDto userDto in users)
            //{
            //    UserViewModel userViewModel = new UserViewModel(userDto);
            //    userViewModels.Add(userViewModel);
            //}

            //return Ok(userViewModels);
        }

        [HttpGet("GetVehicleFuelTypeById")]

        public async Task<IActionResult> GetVehicleFuelType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var vehicleFuelType = await _vehicleFuelTypeManager.GetVehicleFuelType(id);

            if (vehicleFuelType == null)
            {
                return NotFound("VehicleFuelType not found.");
            }

            return Ok(vehicleFuelType);
        }

        [HttpPost("CreateVehicleFuelType")]

        public async Task<IActionResult> CreateVehicleFuelType(VehicleFuelTypeDto dto)
        {
            int message = await _vehicleFuelTypeManager.CreateVehicleFuelType(dto);
            if (message > 0)
            {
                return Ok("VehicleFuelType created successfully.");
            }
            else
            {
                return BadRequest("Failed to create VehicleFuelType.");
            }
        }

        [HttpPut("UpdateVehicleFuelType")]

        public async Task<IActionResult> UpdateVehicleFuelType(VehicleFuelTypeDto dto)
        {
            VehicleFuelTypeDto vehicleFuelType = await _vehicleFuelTypeManager.UpdateVehicleFuelType(dto);

            if (vehicleFuelType == null)
            {
                return NotFound("VehicleFuelType not found.");
            }

            return Ok(vehicleFuelType);
        }

        [HttpDelete("DeleteVehicleFuelType")]

        public async Task<IActionResult> DeleteVehicleFuelType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }
            var vehicleFuelType = await _vehicleFuelTypeManager.GetVehicleFuelType(id);

            if (vehicleFuelType == null)
            {
                return NotFound("VehicleFuelType not found.");
            }

            await _vehicleFuelTypeManager.DeleteVehicleFuelType(id);

            return Ok("Successfully deleted VehicleFuelType");
        }
    }
}
