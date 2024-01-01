using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface IVehicleFuelTypeManager
    {
        public Task<VehicleFuelTypeDto> GetVehicleFuelType(int id);
        public Task<IEnumerable<VehicleFuelTypeDto>> GetAllVehicleFuelTypes();
        public Task<int> CreateVehicleFuelType(VehicleFuelTypeDto dto);
        public Task<VehicleFuelTypeDto> UpdateVehicleFuelType(VehicleFuelTypeDto dto);
        public Task<int> DeleteVehicleFuelType(int id);
    }
}
