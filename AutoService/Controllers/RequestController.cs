using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.ServiceData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RequestController : ControllerBase
    {
        private readonly IRequestManager _requestManager;
        private readonly IAppointmentManager _appointmentManager;
        private readonly IVehicleServiceRecordManager _vehicleRecordManager;
        private readonly IVehicleManager _vehicleManager;
        private readonly IClientManager _clientManager;
        public RequestController(IRequestManager requestManager, IAppointmentManager appointmentManager, IVehicleManager vehicleManager, IClientManager clientManager, IVehicleServiceRecordManager vehicleRecordManager)
        {
            _requestManager = requestManager;
            _appointmentManager = appointmentManager;
            _vehicleManager = vehicleManager;
            _clientManager = clientManager;
            _vehicleRecordManager = vehicleRecordManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllRequests()
        {

            IEnumerable<RequestDto> requests = await _requestManager.GetAllRequests();

            if (requests == null || requests.Count() == 0)
            {
                return NotFound("No Requests found.");
            }


            List<RequestViewModel> requestViewModels = new List<RequestViewModel>();

            foreach (RequestDto requestDto in requests)
            {
                var vehicle = await _vehicleManager.GetVehicle((int)requestDto.VehicleId);
                var client = await _clientManager.GetClient(requestDto.ClientId);
                RequestViewModel requestViewModel = new RequestViewModel(requestDto);
                requestViewModel.VehicleName = vehicle.Make + " " + vehicle.Model;
                requestViewModel.ClientName = client.FirstName + " " + client.LastName;
                requestViewModel.VehicleId = requestDto.VehicleId;
                requestViewModel.AppointmentDate = (DateTime)requestDto.Appointment.Date;
                requestViewModels.Add(requestViewModel);
            }

            return Ok(requestViewModels);
        }

        [HttpGet("GetById")]
        [Authorize]
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
        [Authorize]
        public async Task<IActionResult> CreateRequest(RequestDto dto)
        {
            try
            {
                var vehicle = await _vehicleManager.GetVehicle(dto.VehicleId);
                if (vehicle.Status == Data.Enums.Status.InService
                    || vehicle.Status == Data.Enums.Status.PendingPayment
                    || vehicle.Status == Data.Enums.Status.PickupReady
                    || vehicle.Status == Data.Enums.Status.New
                    || vehicle.Status == Data.Enums.Status.AwaitingCar)
                    return BadRequest("Cannot create a new request while vehicle is busy!");

                dto.Appointment.ClientId = dto.ClientId;
                int requestId = await _requestManager.CreateRequest(dto);
                RequestDto requestDto = await _requestManager.GetRequest(requestId);

                dto.Appointment.Id = (int)requestDto.AppointmentId!;
                dto.Appointment.RequestId = requestDto.Id;

                await _appointmentManager.UpdateAppointment(dto.Appointment);
                return Ok("Request created successfully.");
            }
            catch (Exception e)
            {
                return Problem(e.InnerException.ToString());
            }
        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateRequest(RequestDto dto)
        {
            var vehicle = await _vehicleManager.GetVehicle(dto.VehicleId);
            if (dto.Status == Data.Enums.Status.Completed)
            {

                RequestDto requestDto = await _requestManager.GetRequest(dto.Id);

                RecordDto record = new RecordDto()
                {
                    Cost = dto.TotalCost,
                    ServiceIdList = requestDto.ServiceIdList,
                    VehicleId = dto.VehicleId,
                    Date = DateTime.Now,
                    Notes = requestDto.CustomRequest,
                    MileageAtTimeOfService = vehicle.Mileage,
                };
                await _vehicleRecordManager.CreateVehicleServiceRecord(record);
            }


            Data.Enums.Status newStatus;

            if (dto.Status == Data.Enums.Status.Canceled
                || dto.Status == Data.Enums.Status.Rejected
                || dto.Status == Data.Enums.Status.Completed)
            {
                newStatus = Data.Enums.Status.Idle;
            }
            else
            {
                newStatus = dto.Status;
            }

            VehicleDto vehicleDto = new VehicleDto
            {
                Id = dto.VehicleId,
                Status = newStatus,
                Make = vehicle.Make,
                ManufactureYear = vehicle.ManufactureYear,
                Mileage = vehicle.Mileage,
                Model = vehicle.Model,
                Vin = vehicle.Vin,
                TransmissionTypeId = vehicle.TransmissionTypeId,
                FuelTypeId = vehicle.FuelTypeId,
                VehicleTypeId = vehicle.VehicleTypeId,
            };


            await _vehicleManager.UpdateVehicle(vehicleDto);

            RequestDto request = await _requestManager.UpdateRequest(dto);

            if (request == null)
            {
                return NotFound("Request not found.");
            }

            return Ok(request);
        }

        [HttpDelete("Delete")]
        [Authorize]
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
