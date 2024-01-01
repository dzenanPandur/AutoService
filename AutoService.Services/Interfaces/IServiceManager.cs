using AutoService.Data.DTO.ServiceData;

namespace AutoService.Services.Interfaces
{
    public interface IServiceManager
    {
        public Task<ServiceDto> GetService(int id);
        public Task<IEnumerable<ServiceDto>> GetAllServices();
        public Task<int> CreateService(ServiceDto dto);
        public Task<ServiceDto> UpdateService(ServiceDto dto);
        public Task<int> DeleteService(int id);
    }
}
