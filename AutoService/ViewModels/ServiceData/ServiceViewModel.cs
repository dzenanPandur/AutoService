using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using System.Text.Json.Serialization;

namespace AutoService.ViewModels.ServiceData
{
    public class ServiceViewModel : ServiceDto
    {
        public ServiceViewModel()
        {

        }

        public ServiceViewModel(ServiceDto dto)
        {
            Id = dto.Id;
            Name = dto.Name;
            IsActive = dto.IsActive;
            Price = dto.Price;
            CategoryName = dto.Category.Name;

        }

        public string CategoryName { get; set; }
    }
}
