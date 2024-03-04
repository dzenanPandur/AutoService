using AutoService.Data.DTO.ClientData;
using AutoService.Data.Entities.ServiceData;
using System.Text.Json.Serialization;

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
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public bool? IsOccupied { get; set; }
        public DateTime? Date { get; set; }
        [JsonIgnore]
        public ClientDto? Client { get; set; }
        [JsonIgnore]
        public Guid ClientId { get; set; }
        [JsonIgnore]
        public RequestDto? Request { get; set; }
        [JsonIgnore]
        public int RequestId { get; set; }
    }
}
