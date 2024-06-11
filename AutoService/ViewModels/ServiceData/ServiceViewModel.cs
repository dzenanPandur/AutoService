using AutoService.Data.DTO.ServiceData;

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
            CategoryId = dto.Category.Id;

        }

        public string CategoryName { get; set; }
    }
}
