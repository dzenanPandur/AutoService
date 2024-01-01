using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using AutoService.Services.Managers;
using AutoService.ViewModels.ServiceData;
using AutoService.ViewModels.VehicleData;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

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

        [HttpGet("GetAllRecords")]
        public async Task<IActionResult> GetAllRecords()
        {

            IEnumerable<RecordDto> records = await _recordManager.GetAllVehicleServiceRecords();

            if (records == null || records.Count() == 0)
            {
                return NotFound("No Records found.");
            }

            //return Ok(Records);
            List<RecordViewModel> recordViewModels = new List<RecordViewModel>();

            foreach (RecordDto recordDto in records)
            {
                RecordViewModel recordViewModel = new RecordViewModel(recordDto);
                recordViewModels.Add(recordViewModel);
            }

            return Ok(recordViewModels);
        }

        [HttpGet("GetAllRecordsByVehicle")]
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

            //return Ok(Records);
            List<RecordViewModel> recordViewModels = new List<RecordViewModel>();

            foreach (RecordDto recordDto in records)
            {
                RecordViewModel recordViewModel = new RecordViewModel(recordDto);
                recordViewModels.Add(recordViewModel);
            }

            return Ok(recordViewModels);
        }

        [HttpGet("GetRecordById")]

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

        [HttpPost("CreateRecord")]

        public async Task<IActionResult> CreateRecord(RecordDto dto)
        {
            try
            {
                //dto.ClientId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

                dto.Id = await _recordManager.CreateVehicleServiceRecord(dto);
                //dto.Appointment.ClientId = dto.ClientId;
                //dto.Appointment.RecordId = dto.Id;

                //dto.AppointmentId = await _appointmentManager.CreateAppointment(dto.Appointment);
                //await _recordManager.UpdateRecord(dto);

                return Ok("Record created successfully.");
            }
            catch (Exception e)
            {
                return Problem(e.InnerException.ToString());
            }
        }

        [HttpPut("UpdateRecord")]

        public async Task<IActionResult> UpdateRecord(RecordDto dto)
        {
            RecordDto record = await _recordManager.UpdateVehicleServiceRecord(dto);

            if (record == null)
            {
                return NotFound("Record not found.");
            }

            return Ok(record);
        }

        [HttpDelete("DeleteRecord")]

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
