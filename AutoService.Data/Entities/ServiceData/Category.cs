using AutoService.Data.DTO.ServiceData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ServiceData;

public class Category
{
    public Category() { 

    }

    public Category(CategoryDto dto)
    {
        Id = dto.Id;
        Name = dto.Name;
    }

    [Key]
    public int Id { get; set; }
    public string Name { get; set; }
}
