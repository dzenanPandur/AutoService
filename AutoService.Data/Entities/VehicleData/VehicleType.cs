using AutoService.Data.DTO.VehicleData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.VehicleData;

public class VehicleType
{
    public VehicleType()
    {

    }

    public VehicleType(VehicleTypeDto dto)
    {
        Id = dto.Id;
        Name = dto.Name;
        isActive = dto.isActive;
    }

    [Key]
    public int Id { get; set; }
    public string Name { get; set; }
    public bool isActive { get; set; }
}
