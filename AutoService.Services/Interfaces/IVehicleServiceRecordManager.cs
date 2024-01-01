using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface IVehicleServiceRecordManager
    {
        public Task<RecordDto> GetVehicleServiceRecord(int id);
        public Task<IEnumerable<RecordDto>> GetAllVehicleServiceRecordsByVehicle(int id);
        public Task<IEnumerable<RecordDto>> GetAllVehicleServiceRecords();
        public Task<int> CreateVehicleServiceRecord(RecordDto dto);
        public Task<RecordDto> UpdateVehicleServiceRecord(RecordDto dto);
        public Task<int> DeleteVehicleServiceRecord(int id);
    }
}
