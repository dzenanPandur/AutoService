using AutoService.Data.Database;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using EasyNetQ;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class RequestManager : IRequestManager
    {
        private readonly AutoServiceContext _context;
        private readonly IVehicleServiceRecordManager _vehicleRecordManager;
        private readonly IVehicleManager _vehicleManager;
        private readonly IAppointmentManager _appointmentManager;
        private readonly IUserManager _userManager;
        public RequestManager(AutoServiceContext context, IAppointmentManager appointmentManager, IVehicleServiceRecordManager vehicleRecordManager, IVehicleManager vehicleManager, IUserManager userManager)
        {
            _context = context;
            _appointmentManager = appointmentManager;
            _vehicleRecordManager = vehicleRecordManager;
            _vehicleManager = vehicleManager;
            _userManager = userManager;
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
                .Include(a => a.Services).Include(a => a.Appointment).OrderBy(r => (int)r.Status)
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
            if (dto.Message != requestDto.Message)
            {
                requestDto.Message = dto.Message;
            }
            if (dto.Status == Data.Enums.Status.Completed)
            {
                requestDto.DateCompleted = DateTime.Now;
            }
            requestDto.Status = dto.Status;
            requestDto.TotalCost = dto.TotalCost;

            Request request = new Request(requestDto);
            //// {
            var user = await _userManager.GetUserById(requestDto.ClientId);
            var emailMessage = new EmailMessage
            {
                To = user.Email,
                Subject = $"Status update for request ID {requestDto.Id}",
                Body = $"The request with ID {requestDto.Id} is now in status {requestDto.Status}."
            };
            await PublishEmailMessageAsync(emailMessage);
            // }
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

        public async Task PublishEmailMessageAsync(EmailMessage emailMessage)
        {
            var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

            using (var bus = RabbitHutch.CreateBus($"host={host};virtualHost={virtualHost};username={username};password={password};timeout=30"))
            {
                await bus.PubSub.PublishAsync(emailMessage, "email-queue");
            }
        }
    }
}
