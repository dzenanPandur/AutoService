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
        }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
