using AutoService.Data.DTO.ClientData;
using AutoService.Data.Entities.ServiceData;

namespace AutoService.Data.DTO.ServiceData
{
    public class AppointmentDto
    {
        public AppointmentDto()
        {

        }

        public AppointmentDto(Appointment appointment)
        {
            Id = appointment.Id;
            IsOccupied = appointment.IsOccupied;
            Date = appointment.Date;
            ClientId = appointment.ClientId;
            RequestId = appointment.RequestId;
        }

        public int Id { get; set; }
        public bool? IsOccupied { get; set; }
        public DateTime? Date { get; set; }
        public ClientDto Client { get; set; }
        public Guid ClientId { get; set; }
        public RequestDto Request { get; set; }
        public int RequestId { get; set; }
    }
}
