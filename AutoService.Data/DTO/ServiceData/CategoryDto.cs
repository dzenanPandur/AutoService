using AutoService.Data.Entities.ServiceData;
using System.Text.Json.Serialization;

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

        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
