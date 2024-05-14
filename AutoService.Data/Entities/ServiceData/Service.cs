using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.VehicleData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ServiceData;

public class Service
{
    public Service()
    {

    }

    public Service(ServiceDto dto)
    {
        Id = dto.Id;
        Name = dto.Name;
        IsActive = dto.IsActive;
        Price = dto.Price;
        CategoryId = dto.CategoryId;

        if (dto.Category is not null)
        {
            Category = new Category(dto.Category);
        }
    }

    [Key]
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public bool? IsActive { get; set; }
    public decimal Price { get; set; }
    public int? CategoryId { get; set; }
    public Category? Category { get; set; }
    public ICollection<Request> Requests { get; set; } = new List<Request>();
    public ICollection<ServiceRequest> ServiceRequests { get; set; }
    public ICollection<VehicleServiceRecord> Records { get; set; } = new List<VehicleServiceRecord>();
    public ICollection<ServicesPerformed> ServicesPerformeds { get; set; } = new List<ServicesPerformed>();

}
