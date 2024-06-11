using AutoService.Data.Database;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class TransmissionTypeManager : ITransmissionTypeManager
    {
        private readonly AutoServiceContext _context;
        public TransmissionTypeManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<TransmissionTypeDto> GetTransmissionType(int id)
        {
            TransmissionTypeDto TransmissionType = await _context.TransmissionTypes
                .Where(a => a.Id == id)
                .Select(a => new TransmissionTypeDto(a))
                .FirstOrDefaultAsync();
            return TransmissionType;
        }

        public async Task<IEnumerable<TransmissionTypeDto>> GetAllTransmissionTypes()
        {
            IEnumerable<TransmissionTypeDto> transmissionTypes = await _context.TransmissionTypes
                .Select(a => new TransmissionTypeDto(a))
                .ToListAsync();

            return transmissionTypes;
        }

        public async Task<int> CreateTransmissionType(TransmissionTypeDto dto)
        {
            TransmissionType transmissionType = new TransmissionType(dto);
            _context.ChangeTracker.Clear();
            _context.TransmissionTypes.Add(transmissionType);

            return await _context.SaveChangesAsync();
        }

        public async Task<TransmissionTypeDto> UpdateTransmissionType(TransmissionTypeDto dto)
        {
            TransmissionTypeDto transmissionTypeDto = await GetTransmissionType(dto.Id);
            _context.ChangeTracker.Clear();
            if (dto.Name != null)
            {
                transmissionTypeDto.Name = dto.Name;
            }
            transmissionTypeDto.isActive = dto.isActive;

            TransmissionType transmissionType = new TransmissionType(transmissionTypeDto);

            _context.TransmissionTypes.Update(transmissionType);
            await _context.SaveChangesAsync();

            return transmissionTypeDto;
        }

        public async Task<int> DeleteTransmissionType(int id)
        {
            var transmissionType = await _context.TransmissionTypes.FindAsync(id);

            if (transmissionType == null)
            {
                return 0;
            }

            _context.TransmissionTypes.Remove(transmissionType);
            return await _context.SaveChangesAsync();
        }
    }
}
