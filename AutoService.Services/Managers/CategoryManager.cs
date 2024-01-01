using AutoService.Data.Database;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class CategoryManager : ICategoryManager
    {
        private readonly AutoServiceContext _context;
        public CategoryManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<CategoryDto> GetCategory(int id)
        {
            CategoryDto category = await _context.Categories.Where(a => a.Id == id).Select(a => new CategoryDto(a)).FirstOrDefaultAsync();
            return category;
        }

        public async Task<IEnumerable<CategoryDto>> GetAllCategories()
        {
            IEnumerable<CategoryDto> categories = await _context.Categories.Select(a => new CategoryDto(a)).ToListAsync();

            return categories;
        }

        public async Task<int> CreateCategory(CategoryDto dto)
        {
            Category category = new Category(dto);
            _context.ChangeTracker.Clear();
            _context.Categories.Add(category);

            return await _context.SaveChangesAsync();
        }

        public async Task<CategoryDto> UpdateCategory(CategoryDto dto)
        {
            CategoryDto categoryDto = await GetCategory(dto.Id);
            _context.ChangeTracker.Clear();
            categoryDto.Name = dto.Name;

            Category category = new Category(categoryDto);

            _context.Categories.Update(category);
            await _context.SaveChangesAsync();

            return categoryDto;
        }

        public async Task<int> DeleteCategory(int id)
        {
            var category = await _context.Categories.FindAsync(id);

            if (category == null)
            {
                return 0;
            }

            _context.Categories.Remove(category);
            return await _context.SaveChangesAsync();
        }
    }
}
