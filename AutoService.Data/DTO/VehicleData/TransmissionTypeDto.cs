using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.DTO.VehicleData
{
    public class TransmissionTypeDto
    {
        public TransmissionTypeDto()
        {

        }

        public TransmissionTypeDto(TransmissionType transmissionType)
        {
            Id = transmissionType.Id;
            Name = transmissionType.Name;
        }

        public int Id { get; set; }
        public string Name { get; set; }
    }
}
