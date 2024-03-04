using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ClientData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Data.Enums;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ServiceData;

public class Request
{
    public Request()
    {

    }

    public Request(RequestDto dto)
    {
        Id = dto.Id;
        Status = dto.Status;
        DateRequested = dto.DateRequested;
        DateCompleted = dto.DateCompleted;
        CustomRequest = dto.CustomRequest;
        AppointmentId = dto.AppointmentId;
        ClientId = dto.ClientId;
        VehicleId = dto.VehicleId;

        if (dto.ServiceIdList.Any())
        {
            ServiceRequests = new List<ServiceRequest>(dto.ServiceIdList.Count);
            foreach (int serviceId in dto.ServiceIdList)
            {
                ServiceRequest serviceRequest = new()
                {
                    RequestId = Id,
                    ServiceId = serviceId
                };

                ServiceRequests.Add(serviceRequest);
            }
        }

        if (dto.Vehicle is not null)
        {
            Vehicle = new Vehicle(dto.Vehicle);
        }
    }

    [Key]
    public int Id { get; set; }
    public Status Status { get; set; }
    public DateTime? DateRequested { get; set; }
    public DateTime? DateCompleted { get; set; }
    public string? CustomRequest { get; set; }
    public Appointment? Appointment { get; set; }
    public int? AppointmentId { get; set; }
    public Client Client { get; set; }
    public Guid ClientId { get; set; }
    public Vehicle? Vehicle { get; set; }
    public int? VehicleId { get; set; }
    public ICollection<Service> Services { get; set; } = new List<Service>();
    public ICollection<ServiceRequest> ServiceRequests { get; set; }
}
