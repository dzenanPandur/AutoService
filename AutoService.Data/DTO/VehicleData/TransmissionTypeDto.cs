using AutoService.Data.Entities.VehicleData;
using System.Text.Json.Serialization;

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
            isActive = transmissionType.isActive;
        }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
        public bool isActive { get; set; }
    }
}
