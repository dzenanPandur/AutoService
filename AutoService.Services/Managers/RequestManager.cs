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
        private readonly IAppointmentManager _appointmentManager;
        public RequestManager(AutoServiceContext context, IAppointmentManager appointmentManager)
        {
            _context = context;
            _appointmentManager = appointmentManager;
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

            List<ServiceRequest> serviceRequests = await _context.ServiceRequest
                .Where(sr => sr.RequestId == dto.Id)
                .ToListAsync();

            _context.ServiceRequest.RemoveRange(serviceRequests);

            requestDto.Status = dto.Status;
            requestDto.CustomRequest = dto.CustomRequest;
            requestDto.DateRequested = dto.DateRequested;
            requestDto.DateCompleted = dto.DateCompleted;
            requestDto.AppointmentId = dto.AppointmentId;

            requestDto.ServiceIdList = dto.ServiceIdList
                .Distinct()
                .ToList();

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
