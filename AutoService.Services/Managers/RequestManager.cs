using AutoService.Data.Database;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class RequestManager : IRequestManager
    {
        private readonly AutoServiceContext _context;
        private readonly IVehicleServiceRecordManager _vehicleRecordManager;
        private readonly IVehicleManager _vehicleManager;
        private readonly IAppointmentManager _appointmentManager;
        public RequestManager(AutoServiceContext context, IAppointmentManager appointmentManager, IVehicleServiceRecordManager vehicleRecordManager, IVehicleManager vehicleManager)
        {
            _context = context;
            _appointmentManager = appointmentManager;
            _vehicleRecordManager = vehicleRecordManager;
            _vehicleManager = vehicleManager;
        }

        public async Task<RequestDto> GetRequest(int id)
        {
            RequestDto request = await _context.Request
                .Where(a => a.Id == id)
                .Include(a => a.Services)
                .Select(a => new RequestDto(a))
                .FirstOrDefaultAsync();
            return request;
        }

        public async Task<IEnumerable<RequestDto>> GetAllRequests()
        {

            IEnumerable<RequestDto> Requests = await _context.Request
                .Include(a => a.Services)
                .Select(a => new RequestDto(a))
                .ToListAsync();

            return Requests;
        }

        public async Task<int> CreateRequest(RequestDto dto)
        {
            Request request = new Request(dto);

            _context.ChangeTracker.Clear();
            await _context.Request.AddAsync(request);
            await _context.SaveChangesAsync();

            return request.Id;
        }

        public async Task<RequestDto> UpdateRequest(RequestDto dto)
        {
            RequestDto? requestDto = await GetRequest(dto.Id);
            _context.ChangeTracker.Clear();

            if (requestDto is null)
            {
                return null;
            }
            /*
            if (dto.Status == Data.Enums.Status.Completed)
            {
                var vehicle = await _vehicleManager.GetVehicle(dto.VehicleId);

                RecordDto record = new RecordDto()
                {
                    Cost = dto.TotalCost,
                    ServiceIdList = dto.ServiceIdList,
                    VehicleId = dto.VehicleId,
                    Date = dto.DateCompleted,
                    Notes = string.Empty,
                    MileageAtTimeOfService = vehicle.Mileage,
                };
                await _vehicleRecordManager.CreateVehicleServiceRecord(record);
            }
            */
            /*List<ServiceRequest> serviceRequests = await _context.ServiceRequest
                .Where(sr => sr.RequestId == dto.Id)
                .ToListAsync();
            
            _context.ServiceRequest.RemoveRange(serviceRequests);
            */
            requestDto.Status = dto.Status;
            requestDto.TotalCost = dto.TotalCost;

            Request request = new Request(requestDto);

            _context.Request.Update(request);
            await _context.SaveChangesAsync();

            return requestDto;
        }

        public async Task<int> DeleteRequest(int id)
        {
            var request = await _context.Request.FindAsync(id);

            if (request == null)
            {
                return 0;
            }

            _context.Request.Remove(request);
            return await _context.SaveChangesAsync();
        }
    }
}
