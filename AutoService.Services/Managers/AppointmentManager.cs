using AutoService.Data.Database;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class AppointmentManager : IAppointmentManager
    {
        private readonly AutoServiceContext _context;
        public AppointmentManager(AutoServiceContext context)
        {
            _context = context;
        }

        public async Task<AppointmentDto> GetAppointment(int id)
        {
            AppointmentDto appointment = await _context.Appointments.Where(a => a.Id == id).Select(a => new AppointmentDto(a)).FirstOrDefaultAsync();
            return appointment;
        }

        public async Task<IEnumerable<AppointmentDto>> GetAllAppointments()
        {
            IEnumerable<AppointmentDto> appointments = await _context.Appointments.Select(a => new AppointmentDto(a)).ToListAsync();

            return appointments;
        }

        public async Task<int> CreateAppointment(AppointmentDto dto)
        {
            Appointment appointment = new Appointment(dto);
            _context.ChangeTracker.Clear();
            _context.Appointments.Add(appointment);

            await _context.SaveChangesAsync();

            return appointment.Id;
        }

        public async Task<AppointmentDto> UpdateAppointment(AppointmentDto dto)
        {
            AppointmentDto appointmentDto = await GetAppointment(dto.Id);
            _context.ChangeTracker.Clear();

            appointmentDto.Date = dto.Date;
            appointmentDto.IsOccupied = dto.IsOccupied;
            appointmentDto.RequestId = dto.RequestId;

            Appointment appointment = new Appointment(appointmentDto);

            _context.Appointments.Update(appointment);
            await _context.SaveChangesAsync();

            return appointmentDto;
        }

        public async Task<int> DeleteAppointment(int id)
        {
            var appointment = await _context.Appointments.FindAsync(id);

            if (appointment == null)
            {
                return 0;
            }

            _context.Appointments.Remove(appointment);
            return await _context.SaveChangesAsync();
        }

    }
}
