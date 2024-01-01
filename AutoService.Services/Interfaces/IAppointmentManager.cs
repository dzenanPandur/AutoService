using AutoService.Data.DTO.ServiceData;

namespace AutoService.Services.Interfaces
{
    public interface IAppointmentManager
    {
        public Task<AppointmentDto> GetAppointment(int id);
        public Task<IEnumerable<AppointmentDto>> GetAllAppointments();
        public Task<int> CreateAppointment(AppointmentDto dto);
        public Task<AppointmentDto> UpdateAppointment(AppointmentDto dto);
        public Task<int> DeleteAppointment(int id);
    }
}
