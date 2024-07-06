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
        private readonly IUserManager _userManager;
        private readonly IVehicleManager _vehicleManager;
        public RequestManager(AutoServiceContext context, IUserManager userManager, IVehicleManager vehicleManager)
        {
            _context = context;
            _userManager = userManager;
            _vehicleManager = vehicleManager;
        }

        public async Task<RequestDto> GetRequest(int id)
        {
            RequestDto request = await _context.Request
                .Where(r => r.Id == id)
                .Include(r => r.Services)
                .Include(r => r.Appointment)
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

            bool statusChanged = dto.Status != requestDto.Status;
            requestDto.Status = dto.Status;
            requestDto.TotalCost = dto.TotalCost;

            Request request = new Request(requestDto);
            if (statusChanged)
            {
                var user = await _userManager.GetUserById(requestDto.ClientId);
                var vehicle = await _vehicleManager.GetVehicle(requestDto.VehicleId);
                var emailMessage = new EmailMessage
                {
                    To = user.Email,
                    Subject = $"Status update for Your request ({vehicle.Make} {vehicle.Model})",
                    Body = $"The request for Your vehicle {vehicle.Make} {vehicle.Model} is now in status {requestDto.Status}."
                };
                await PublishEmailMessageAsync(emailMessage);
            }
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
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "user";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "test";

            using (var bus = RabbitHutch.CreateBus($"host={host};virtualHost={virtualHost};username={username};password={password};timeout=30"))
            {
                await bus.PubSub.PublishAsync(emailMessage, "email-queue");
            }
        }
    }
}
