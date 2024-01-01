using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface IVehicleManager
    {
        public Task<VehicleDto> GetVehicle(int id);
        public Task<IEnumerable<VehicleDto>> GetAllVehicles();
        public Task<int> CreateVehicle(VehicleDto dto);
        public Task<VehicleDto> UpdateVehicle(VehicleDto dto);
        public Task<int> DeleteVehicle(int id);
    }
}
