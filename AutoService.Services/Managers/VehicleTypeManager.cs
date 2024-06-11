using AutoService.Data.Database;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class VehicleTypeManager : IVehicleTypeManager
    {
        private readonly AutoServiceContext _context;
        public VehicleTypeManager(AutoServiceContext context)
        {

            _context = context;
        }

        public async Task<VehicleTypeDto> GetVehicleType(int id)
        {
            VehicleTypeDto vehicleType = await _context.VehicleTypes.Where(a => a.Id == id).Select(a => new VehicleTypeDto(a)).FirstOrDefaultAsync();
            return vehicleType;
        }

        public async Task<IEnumerable<VehicleTypeDto>> GetAllVehicleTypes()
        {
            IEnumerable<VehicleTypeDto> vehicleTypes = await _context.VehicleTypes.Select(a => new VehicleTypeDto(a)).ToListAsync();

            return vehicleTypes;
        }

        public async Task<int> CreateVehicleType(VehicleTypeDto dto)
        {
            VehicleType vehicleType = new VehicleType(dto);
            _context.ChangeTracker.Clear();
            _context.VehicleTypes.Add(vehicleType);

            return await _context.SaveChangesAsync();
        }

        public async Task<VehicleTypeDto> UpdateVehicleType(VehicleTypeDto dto)
        {
            VehicleTypeDto vehicleTypeDto = await GetVehicleType(dto.Id);
            _context.ChangeTracker.Clear();

            if (dto.Name != null)
            {
                vehicleTypeDto.Name = dto.Name;
            }

            vehicleTypeDto.isActive = dto.isActive;

            VehicleType vehicleType = new VehicleType(vehicleTypeDto);

            _context.VehicleTypes.Update(vehicleType);
            await _context.SaveChangesAsync();

            return vehicleTypeDto;
        }

        public async Task<int> DeleteVehicleType(int id)
        {
            var vehicleType = await _context.VehicleTypes.FindAsync(id);

            if (vehicleType == null)
            {
                return 0;
            }

            _context.VehicleTypes.Remove(vehicleType);
            return await _context.SaveChangesAsync();
        }
    }
}
