using AutoService.Data.Database;
using AutoService.Data.DTO.ClientData;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.UserData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ClientData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class ClientManager : IClientManager
    {
        private readonly AutoServiceContext _context;
        public ClientManager(AutoServiceContext context)
        {
            _context = context;
        }
        //public async Task<ClientDto> GetClient(Guid id)
        //{
        //    ClientDto client = await _context.Clients
        //        .Where(a => a.Id == id)
        //        .Select(a => new ClientDto(a))
        //        .FirstOrDefaultAsync();

        //    return client;
        //}

        public async Task<UserDto> GetClient(Guid id)
        {
            UserDto client = await _context.Users
                .Where(a => a.Id == id)
                .Select(a => new UserDto(a))
                .FirstOrDefaultAsync();

            return client;
        }

        //public async Task<IEnumerable<ClientDto>> GetAllClients()
        //{
        //    IEnumerable<ClientDto> clients = await _context.Clients
        //        .Include(c => c.Role)
        //        .Where(c => c.Role.Name == "Client")
        //        .Select(a => new ClientDto(a))
        //        .ToListAsync();

        //    return clients;
        //}

        public async Task<IEnumerable<UserDto>> GetAllClients()
        {
            IEnumerable<UserDto> clients = await _context.Users
                .Include(c => c.Role)
                .Where(c => c.Role.Name == "Client")
                .Select(a => new UserDto(a))
                .ToListAsync();

            return clients;
        }
        public async Task<IEnumerable<RequestDto>> GetAllRequestsByClient(Guid clientId)
        {
            IEnumerable<RequestDto> requests = await _context.Request
                .Where(r => r.ClientId == clientId)
                .Select(r => new RequestDto(r))
                .ToListAsync();
            
            return requests;
        }

        public async Task<IEnumerable<AppointmentDto>> GetAllAppointmentsByClient(Guid clientId)
        {
            IEnumerable<AppointmentDto> appointments = await _context.Appointments
                .Where(a => a.ClientId == clientId)
                .Select(a => new AppointmentDto(a))
                .ToListAsync();

            return appointments;
        }

        public async Task<IEnumerable<VehicleDto>> GetAllVehiclesByClient(Guid clientId)
        {
            IEnumerable<VehicleDto> vehicles = await _context.Vehicles
                .Include(vt => vt.VehicleType)
                .Include(tt => tt.TransmissionType)
                .Include(ft => ft.FuelType)
                .Where(v => v.ClientId == clientId)
                .Select(v => new VehicleDto(v))
                .ToListAsync();

            return vehicles;
        }
    }
}
