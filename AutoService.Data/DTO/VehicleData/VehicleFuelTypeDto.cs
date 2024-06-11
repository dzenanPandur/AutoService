using AutoService.Data.Entities.VehicleData;
using System.Text.Json.Serialization;

namespace AutoService.Data.DTO.VehicleData
{
    public class VehicleFuelTypeDto
    {
        public VehicleFuelTypeDto()
        {

        }

        public VehicleFuelTypeDto(VehicleFuelType vehicleFuelType)
        {
            Id = vehicleFuelType.Id;
            Name = vehicleFuelType.Name;
            isActive = vehicleFuelType.isActive;
        }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
        public bool isActive { get; set; }
    }
}
