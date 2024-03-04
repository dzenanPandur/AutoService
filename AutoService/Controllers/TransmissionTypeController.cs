using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
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
        public async Task<IActionResult> GetAllTransmissionTypes()
        {

            IEnumerable<TransmissionTypeDto> transmissionTypes = await _transmissionTypeManager.GetAllTransmissionTypes();

            if (transmissionTypes == null || transmissionTypes.Count() == 0)
            {
                return NotFound("No TransmissionTypes found.");
            }

            return Ok(transmissionTypes);
            //List<UserViewModel> userViewModels = new List<UserViewModel>();

            //foreach (UserDto userDto in users)
            //{
            //    UserViewModel userViewModel = new UserViewModel(userDto);
            //    userViewModels.Add(userViewModel);
            //}

            //return Ok(userViewModels);
        }

        [HttpGet("GetById")]

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
