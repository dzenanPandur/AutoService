using AutoService.Data.DTO.ClientData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Enums;
using System.Text.Json.Serialization;

namespace AutoService.Data.DTO.ServiceData
{
    public class RequestDto
    {
        public RequestDto()
        {

        }

        public RequestDto(Request request)
        {
            Id = request.Id;
            Status = request.Status;
            DateRequested = request.DateRequested;
            DateCompleted = request.DateCompleted;
            CustomRequest = request.CustomRequest;
            AppointmentId = request.AppointmentId;
            ClientId = request.ClientId;
            VehicleId = request.VehicleId;


            if (request.Services is not null)
            {
                Services = new List<ServiceDto>(
                    request.Services
                        .Select(s => new ServiceDto(s))
                        .ToList());

                ServiceIdList = request.Services
                    .Select(s => s.Id)
                    .ToList();
            }

            if (request.Vehicle is not null)
            {
                Vehicle = new VehicleDto(request.Vehicle);
            }
        }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public Status Status { get; set; }
        public DateTime? DateRequested { get; set; }
        public DateTime? DateCompleted { get; set; }
        public string? CustomRequest { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public AppointmentDto? Appointment { get; set; }
        [JsonIgnore]
        public int? AppointmentId { get; set; }
        [JsonIgnore]
        public ClientDto? Client { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public Guid ClientId { get; set; }
        [JsonIgnore]
        public VehicleDto? Vehicle { get; set; }
        //[JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int? VehicleId { get; set; }
        [JsonIgnore]
        public ICollection<ServiceDto> Services { get; set; } = new List<ServiceDto>();
        public ICollection<int> ServiceIdList { get; set; } = new List<int>();
    }
}
