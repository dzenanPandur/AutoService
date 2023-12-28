using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.DTO.ServiceData
{
    public class ServiceDto
    {
        public ServiceDto()
        {

        }

        public ServiceDto(Service service)
        {
            Id = service.Id;
            Name = service.Name;
            IsActive = service.IsActive;
            Price = service.Price;
            CategoryId = service.CategoryId;

            if (service.Category is not null)
            {
                Category = new CategoryDto(service.Category);
            }
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public bool? IsActive { get; set; }
        public decimal Price { get; set; }
        public CategoryDto? Category { get; set; }
        public int? CategoryId { get; set; }
        public ICollection<int> RequestIdList { get; set; } = new List<int>();
        public ICollection<RequestDto> Requests { get; set; } = new List<RequestDto>();
        public ICollection<VehicleServiceRecord> Records { get; set; } = new List<VehicleServiceRecord>();
    }
}
