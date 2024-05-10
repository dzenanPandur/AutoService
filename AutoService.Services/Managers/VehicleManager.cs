using AutoService.Data.Database;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class VehicleManager : IVehicleManager
    {
        private readonly AutoServiceContext _context;

        public VehicleManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<VehicleDto> GetVehicle(int id)
        {
            VehicleDto vehicle = await _context.Vehicles.Where(a => a.Id == id)
                .Include(v => v.VehicleType)
                .Include(t => t.TransmissionType)
                .Include(f => f.FuelType)
                .Select(a => new VehicleDto(a)).FirstOrDefaultAsync();
            return vehicle;
        }

        public async Task<IEnumerable<VehicleDto>> GetAllVehicles()
        {
            IEnumerable<VehicleDto> vehicles = await _context.Vehicles
                .Include(v => v.VehicleType)
                .Include(t => t.TransmissionType)
                .Include(f => f.FuelType)
                .Select(a => new VehicleDto(a)).ToListAsync();

            return vehicles;
        }

        public async Task<int> CreateVehicle(VehicleDto dto)
        {
            Vehicle vehicle = new Vehicle(dto);
            _context.ChangeTracker.Clear();
            _context.Vehicles.AddAsync(vehicle);

            return await _context.SaveChangesAsync();
        }

        public async Task<VehicleDto> UpdateVehicle(VehicleDto dto)
        {
            VehicleDto vehicleDto = await GetVehicle(dto.Id);
            _context.ChangeTracker.Clear();

            vehicleDto.Status = dto.Status;
            vehicleDto.Make = dto.Make;
            vehicleDto.Vin = dto.Vin;
            vehicleDto.ManufactureYear = dto.ManufactureYear;
            vehicleDto.Mileage = dto.Mileage;
            vehicleDto.Model = dto.Model;
            //vehicleDto.FuelType.Id = (int)dto.FuelTypeId;
            //vehicleDto.TransmissionType.Id = (int)dto.TransmissionTypeId;
            //vehicleDto.VehicleType.Id = (int)dto.VehicleTypeId;
            //vehicleDto.FuelType.Name = dto.VehicleType.Name;

            Vehicle vehicle = new Vehicle(vehicleDto);

            _context.Vehicles.Update(vehicle);
            await _context.SaveChangesAsync();

            return vehicleDto;
        }

        public async Task<int> DeleteVehicle(int id)
        {
            var vehicle = await _context.Vehicles.FindAsync(id);

            if (vehicle == null)
            {
                return 0;
            }

            //_context.Vehicles.Remove(vehicle);

            vehicle.isArchived = true;

            _context.Vehicles.Update(vehicle);
            return await _context.SaveChangesAsync();
        }
    }
}
