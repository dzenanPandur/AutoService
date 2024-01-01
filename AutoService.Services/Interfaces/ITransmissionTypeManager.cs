using AutoService.Data.DTO.VehicleData;

namespace AutoService.Services.Interfaces
{
    public interface ITransmissionTypeManager
    {
        public Task<TransmissionTypeDto> GetTransmissionType(int id);
        public Task<IEnumerable<TransmissionTypeDto>> GetAllTransmissionTypes();
        public Task<int> CreateTransmissionType(TransmissionTypeDto dto);
        public Task<TransmissionTypeDto> UpdateTransmissionType(TransmissionTypeDto dto);
        public Task<int> DeleteTransmissionType(int id);
    }
}
