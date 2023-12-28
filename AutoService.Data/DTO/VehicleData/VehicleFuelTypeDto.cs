using AutoService.Data.Entities.VehicleData;

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
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
