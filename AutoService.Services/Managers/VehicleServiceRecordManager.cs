using AutoService.Data.Database;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class VehicleServiceRecordManager : IVehicleServiceRecordManager
    {
        private readonly AutoServiceContext _context;
        public VehicleServiceRecordManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<RecordDto> GetVehicleServiceRecord(int id)
        {
            RecordDto vehicleServiceRecord = await _context.VehicleServiceRecords
                .Where(a => a.Id == id)
                .Select(a => new RecordDto(a))
                .FirstOrDefaultAsync();
            return vehicleServiceRecord;
        }

        public async Task<IEnumerable<RecordDto>> GetAllVehicleServiceRecordsByVehicle(int id)
        {
            IEnumerable<RecordDto> vehicleServiceRecords = await _context.VehicleServiceRecords
                .Where(a => a.VehicleId == id)
                .Include(a => a.Services)
                .Select(a => new RecordDto(a))
                .ToListAsync();

            return vehicleServiceRecords;
        }

        public async Task<IEnumerable<RecordDto>> GetAllVehicleServiceRecords()
        {
            IEnumerable<RecordDto> vehicleServiceRecords = await _context.VehicleServiceRecords
                .Include(a => a.Vehicle)
                .Include(a => a.Services)
                .Select(a => new RecordDto(a))
                .ToListAsync();

            return vehicleServiceRecords;
        }

        public async Task<int> CreateVehicleServiceRecord(RecordDto dto)
        {
            VehicleServiceRecord vehicleServiceRecord = new VehicleServiceRecord(dto);
            _context.ChangeTracker.Clear();
            _context.VehicleServiceRecords.Add(vehicleServiceRecord);

            return await _context.SaveChangesAsync();
        }

        public async Task<RecordDto> UpdateVehicleServiceRecord(RecordDto dto)
        {
            RecordDto vehicleServiceRecordDto = await GetVehicleServiceRecord(dto.Id);
            _context.ChangeTracker.Clear();
            List<ServicesPerformed> servicesPerformed = await _context.ServicesPerformed
                .Where(sp => sp.RecordId == dto.Id)
                .ToListAsync();

            _context.ServicesPerformed.RemoveRange(servicesPerformed);

            vehicleServiceRecordDto.Cost = dto.Cost;
            vehicleServiceRecordDto.Date = dto.Date;
            vehicleServiceRecordDto.MileageAtTimeOfService = dto.MileageAtTimeOfService;
            vehicleServiceRecordDto.Notes = dto.Notes;
            vehicleServiceRecordDto.ServiceIdList = dto.ServiceIdList
                .Distinct()
                .ToList();

            VehicleServiceRecord vehicleServiceRecord = new VehicleServiceRecord(vehicleServiceRecordDto);

            _context.VehicleServiceRecords.Update(vehicleServiceRecord);
            await _context.SaveChangesAsync();

            return vehicleServiceRecordDto;
        }

        public async Task<int> DeleteVehicleServiceRecord(int id)
        {
            var vehicleServiceRecord = await _context.VehicleServiceRecords.FindAsync(id);

            if (vehicleServiceRecord == null)
            {
                return 0;
            }

            _context.VehicleServiceRecords.Remove(vehicleServiceRecord);
            return await _context.SaveChangesAsync();
        }
    }
}
