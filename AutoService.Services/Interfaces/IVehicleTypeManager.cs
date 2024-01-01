using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface IVehicleTypeManager
    {
        public Task<VehicleTypeDto> GetVehicleType(int id);
        public Task<IEnumerable<VehicleTypeDto>> GetAllVehicleTypes();
        public Task<int> CreateVehicleType(VehicleTypeDto dto);
        public Task<VehicleTypeDto> UpdateVehicleType(VehicleTypeDto dto);
        public Task<int> DeleteVehicleType(int id);
    }
}
