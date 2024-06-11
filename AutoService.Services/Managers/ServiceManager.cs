using AutoService.Data.Database;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class ServiceManager : IServiceManager
    {
        private readonly AutoServiceContext _context;
        public ServiceManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<ServiceDto> GetService(int id)
        {
            ServiceDto service = await _context.Services
                .Where(a => a.Id == id)
                .Select(a => new ServiceDto(a))
                .FirstOrDefaultAsync();
            return service;
        }

        public async Task<IEnumerable<ServiceDto>> GetAllServices()
        {
            IEnumerable<ServiceDto> services = await _context.Services
                .Include(c => c.Category)
                .Select(a => new ServiceDto(a))
                .ToListAsync();

            return services;
        }

        public async Task<int> CreateService(ServiceDto dto)
        {
            Service service = new Service(dto);
            _context.ChangeTracker.Clear();
            _context.Services.Add(service);

            return await _context.SaveChangesAsync();
        }

        public async Task<ServiceDto> UpdateService(ServiceDto dto)
        {
            ServiceDto serviceDto = await GetService(dto.Id);
            _context.ChangeTracker.Clear();

            if (serviceDto.Name != null || serviceDto.CategoryId != null)
            {
                serviceDto.Name = dto.Name;
                serviceDto.Price = dto.Price;
                serviceDto.CategoryId = dto.CategoryId;
            }
            serviceDto.IsActive = dto.IsActive;

            Service service = new Service(serviceDto);

            _context.Services.Update(service);
            await _context.SaveChangesAsync();

            return serviceDto;
        }

        public async Task<int> DeleteService(int id)
        {
            var service = await _context.Services.FindAsync(id);

            if (service == null)
            {
                return 0;
            }

            _context.Services.Remove(service);
            return await _context.SaveChangesAsync();
        }
    }
}
