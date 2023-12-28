using AutoService.Data.Entities.VehicleData;

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
        }

        public int Id { get; set; }
        public string Name { get; set; }
    }
}
