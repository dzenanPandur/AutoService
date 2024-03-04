using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;
using System.Text.Json.Serialization;

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

        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
        public bool? IsActive { get; set; }
        public decimal Price { get; set; }
        [JsonIgnore]
        public CategoryDto? Category { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int? CategoryId { get; set; }
        [JsonIgnore]
        public ICollection<int> RequestIdList { get; set; } = new List<int>();

        [JsonIgnore]
        public ICollection<RequestDto> Requests { get; set; } = new List<RequestDto>();
        [JsonIgnore]
        public ICollection<VehicleServiceRecord> Records { get; set; } = new List<VehicleServiceRecord>();
    }
}
