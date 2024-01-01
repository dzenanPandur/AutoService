using AutoService.Data.DTO.ServiceData;

namespace AutoService.Services.Interfaces
{
    public interface ICategoryManager
    {
        public Task<CategoryDto> GetCategory(int id);
        public Task<IEnumerable<CategoryDto>> GetAllCategories();
        public Task<int> CreateCategory(CategoryDto dto);
        public Task<CategoryDto> UpdateCategory(CategoryDto dto);
        public Task<int> DeleteCategory(int id);
    }
}
