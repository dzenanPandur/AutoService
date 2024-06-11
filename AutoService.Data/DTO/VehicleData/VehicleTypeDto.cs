using AutoService.Data.Entities.VehicleData;
using System.Text.Json.Serialization;

namespace AutoService.Data.DTO.VehicleData
{
    public class VehicleTypeDto
    {
        public VehicleTypeDto()
        {

        }

        public VehicleTypeDto(VehicleType vehicleType)
        {
            Id = vehicleType.Id;
            Name = vehicleType.Name;
            isActive = vehicleType.isActive;
        }

        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
        public bool isActive { get; set; }
    }
}
