using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.VehicleData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VehicleServiceRecordController : ControllerBase
    {
        private readonly IVehicleServiceRecordManager _recordManager;
        public VehicleServiceRecordController(IVehicleServiceRecordManager recordManager)
        {
            _recordManager = recordManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllRecords()
        {

            IEnumerable<RecordDto> records = await _recordManager.GetAllVehicleServiceRecords();

            if (records == null || records.Count() == 0)
            {
                return NotFound("No Records found.");
            }

            List<RecordViewModel> recordViewModels = new List<RecordViewModel>();

            foreach (RecordDto recordDto in records)
            {
                RecordViewModel recordViewModel = new RecordViewModel(recordDto);
                recordViewModels.Add(recordViewModel);
            }

            return Ok(recordViewModels);
        }

        [HttpGet("GetAllRecordsByVehicle")]
        [Authorize]
        public async Task<IActionResult> GetAllRecordsByVehicle(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            IEnumerable<RecordDto> records = await _recordManager.GetAllVehicleServiceRecordsByVehicle(id);

            if (records == null || records.Count() == 0)
            {
                return NotFound("No Records found.");
            }

            List<RecordViewModel> recordViewModels = new List<RecordViewModel>();

            foreach (RecordDto recordDto in records)
            {
                RecordViewModel recordViewModel = new RecordViewModel(recordDto);
                recordViewModels.Add(recordViewModel);
            }

            return Ok(recordViewModels);
        }

        [HttpGet("GetById")]
        [Authorize]
        public async Task<IActionResult> GetRecord(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var Record = await _recordManager.GetVehicleServiceRecord(id);

            if (Record == null)
            {
                return NotFound("Record not found.");
            }

            return Ok(Record);
        }

        [HttpPost("Create")]
        [Authorize]
        public async Task<IActionResult> CreateRecord(RecordDto dto)
        {
            try
            {

                dto.Id = await _recordManager.CreateVehicleServiceRecord(dto);

                return Ok("Record created successfully.");
            }
            catch (Exception e)
            {
                return Problem(e.InnerException.ToString());
            }
        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateRecord(RecordDto dto)
        {
            RecordDto record = await _recordManager.UpdateVehicleServiceRecord(dto);

            if (record == null)
            {
                return NotFound("Record not found.");
            }

            return Ok(record);
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteRecord(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var record = await _recordManager.GetVehicleServiceRecord(id);

            if (record == null)
            {
                return NotFound("Record not found.");
            }

            await _recordManager.DeleteVehicleServiceRecord(id);

            return Ok("Successfully deleted Record");
        }
    }
}
