using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ClientData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ServiceData;

public class Appointment
{
    public Appointment()
    {

    }

    public Appointment(AppointmentDto dto)
    {
        Id = dto.Id;
        IsOccupied = dto.IsOccupied;
        Date = dto.Date;
        ClientId = dto.ClientId;
        RequestId = dto.RequestId;
    }

    [Key]
    public int Id { get; set; }
    public bool? IsOccupied { get; set; }
    public DateTime? Date { get; set; }
    public Client Client { get; set; }
    public Guid ClientId { get; set; }
    public Request Request { get; set; }
    public int RequestId { get; set; }
}
