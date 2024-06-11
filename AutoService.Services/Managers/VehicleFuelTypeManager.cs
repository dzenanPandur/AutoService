using AutoService.Data.Database;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class VehicleFuelTypeManager : IVehicleFuelTypeManager
    {
        private readonly AutoServiceContext _context;
        public VehicleFuelTypeManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<VehicleFuelTypeDto> GetVehicleFuelType(int id)
        {
            VehicleFuelTypeDto vehicleFuelType = await _context.VehicleFuelTypes.Where(a => a.Id == id).Select(a => new VehicleFuelTypeDto(a)).FirstOrDefaultAsync();
            return vehicleFuelType;
        }

        public async Task<IEnumerable<VehicleFuelTypeDto>> GetAllVehicleFuelTypes()
        {
            IEnumerable<VehicleFuelTypeDto> vehicleFuelTypes = await _context.VehicleFuelTypes.Select(a => new VehicleFuelTypeDto(a)).ToListAsync();

            return vehicleFuelTypes;
        }

        public async Task<int> CreateVehicleFuelType(VehicleFuelTypeDto dto)
        {
            VehicleFuelType vehicleFuelType = new VehicleFuelType(dto);
            _context.ChangeTracker.Clear();
            _context.VehicleFuelTypes.Add(vehicleFuelType);

            return await _context.SaveChangesAsync();
        }

        public async Task<VehicleFuelTypeDto> UpdateVehicleFuelType(VehicleFuelTypeDto dto)
        {
            VehicleFuelTypeDto vehicleFuelTypeDto = await GetVehicleFuelType(dto.Id);
            _context.ChangeTracker.Clear();
            if (dto.Name != null)
            {
                vehicleFuelTypeDto.Name = dto.Name;
            }
            vehicleFuelTypeDto.isActive = dto.isActive;

            VehicleFuelType vehicleFuelType = new VehicleFuelType(vehicleFuelTypeDto);

            _context.VehicleFuelTypes.Update(vehicleFuelType);
            await _context.SaveChangesAsync();

            return vehicleFuelTypeDto;
        }

        public async Task<int> DeleteVehicleFuelType(int id)
        {
            var vehicleFuelType = await _context.VehicleFuelTypes.FindAsync(id);

            if (vehicleFuelType == null)
            {
                return 0;
            }

            _context.VehicleFuelTypes.Remove(vehicleFuelType);
            return await _context.SaveChangesAsync();
        }
    }
}
