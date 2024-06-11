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

        private readonly IServiceManager _serviceManager;
        public CategoryManager(AutoServiceContext context, IServiceManager serviceManager)
        {
            _context = context;
            _serviceManager = serviceManager;
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

            if (categoryDto is null)
            {
                return null;
            }
            if (dto.Name != null)
            {
                categoryDto.Name = dto.Name;
            }
            categoryDto.isActive = dto.isActive;
            Category category = new Category(categoryDto);

            if (!dto.isActive)
            {
                var services = await _context.Services
                    .Where(s => s.CategoryId == dto.Id)
                    .ToListAsync();

                foreach (var service in services)
                {
                    ServiceDto serviceDto = new ServiceDto(service)
                    {
                        IsActive = false
                    };
                    await _serviceManager.UpdateService(serviceDto);
                }
            }

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
