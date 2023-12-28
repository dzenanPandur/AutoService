using AutoService.Data.Entities.ServiceData;

namespace AutoService.Data.DTO.ServiceData
{
    public class CategoryDto
    {
        public CategoryDto()
        {

        }

        public CategoryDto(Category category)
        {
            Id = category.Id;
            Name = category.Name;
        }

        public int Id { get; set; }
        public string Name { get; set; }
    }
}
