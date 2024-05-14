using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.UserData;
using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface IClientManager
    {
        public Task<UserDto> GetClient(Guid id);
        public Task<IEnumerable<UserDto>> GetAllClients();
        public Task<IEnumerable<RequestDto>> GetAllRequestsByClient(Guid clientId);
        public Task<IEnumerable<RequestDto>> GetAllMessagesByClient(Guid clientId);
        public Task<IEnumerable<AppointmentDto>> GetAllAppointmentsByClient(Guid clientId);
        public Task<IEnumerable<VehicleDto>> GetAllVehiclesByClient(Guid clientId);

    }
}
