using AutoService.Data.DTO.VehicleData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.VehicleData;

public class VehicleFuelType
{
    public VehicleFuelType()
    {

    }

    public VehicleFuelType(VehicleFuelTypeDto dto)
    {
        Id = dto.Id;
        Name = dto.Name;
    }

    [Key]
    public int Id { get; set; }
    public string Name { get; set; }
}
