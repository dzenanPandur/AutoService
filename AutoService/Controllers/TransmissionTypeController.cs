using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class TransmissionTypeController : ControllerBase
    {
        private readonly ITransmissionTypeManager _transmissionTypeManager;
        public TransmissionTypeController(ITransmissionTypeManager transmissionTypeManager)
        {
            _transmissionTypeManager = transmissionTypeManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllTransmissionTypes()
        {

            IEnumerable<TransmissionTypeDto> transmissionTypes = await _transmissionTypeManager.GetAllTransmissionTypes();

            if (transmissionTypes == null || transmissionTypes.Count() == 0)
            {
                return NotFound("No TransmissionTypes found.");
            }

            return Ok(transmissionTypes);
        }

        [HttpGet("GetById")]
        [Authorize]

        public async Task<IActionResult> GetTransmissionType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var transmissionType = await _transmissionTypeManager.GetTransmissionType(id);

            if (transmissionType == null)
            {
                return NotFound("TransmissionType not found.");
            }

            return Ok(transmissionType);
        }

        [HttpPost("Create")]
        [Authorize]
        public async Task<IActionResult> CreateTransmissionType(TransmissionTypeDto dto)
        {
            int message = await _transmissionTypeManager.CreateTransmissionType(dto);
            if (message > 0)
            {
                return Ok("TransmissionType created successfully.");
            }
            else
            {
                return BadRequest("Failed to create TransmissionType.");
            }
        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateTransmissionType(TransmissionTypeDto dto)
        {
            TransmissionTypeDto transmissionType = await _transmissionTypeManager.UpdateTransmissionType(dto);

            if (transmissionType == null)
            {
                return NotFound("TransmissionType not found.");
            }

            return Ok(transmissionType);
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteTransmissionType(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var transmissionType = await _transmissionTypeManager.GetTransmissionType(id);

            if (transmissionType == null)
            {
                return NotFound("TransmissionType not found.");
            }

            await _transmissionTypeManager.DeleteTransmissionType(id);

            return Ok("Successfully deleted TransmissionType");
        }
    }
}
