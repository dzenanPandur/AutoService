using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.UserData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ClientData;

namespace AutoService.Data.DTO.ClientData
{
    public class ClientDto : UserDto
    {
        public ClientDto()
        {

        }

        public ClientDto(Client client)
        {

            if (client.Appointments is not null)
            {
                Appointments = new List<AppointmentDto>(
                    client.Appointments
                    .Select(r => new AppointmentDto(r))
                    .ToList());

                AppointmentIdList = client.Appointments
                    .Select(r => r.Id)
                    .ToList();
            }

            if (client.Requests is not null)
            {
                Requests = new List<RequestDto>(
                    client.Requests
                    .Select(r => new RequestDto(r))
                    .ToList());

                RequestIdList = client.Requests
                    .Select(r => r.Id)
                    .ToList();
            }

            if (client.Vehicles is not null)
            {
                Vehicles = new List<VehicleDto>(
                    client.Vehicles
                    .Select(r => new VehicleDto(r))
                    .ToList());

                VehicleIdList = client.Vehicles
                    .Select(r => r.Id)
                    .ToList();
            }
        }
        public ICollection<AppointmentDto> Appointments { get; set; } = new List<AppointmentDto>();
        public ICollection<int> AppointmentIdList { get; set; } = new List<int>();
        public ICollection<RequestDto> Requests { get; set; } = new List<RequestDto>();
        public ICollection<int> RequestIdList { get; set; } = new List<int>();
        public ICollection<VehicleDto> Vehicles { get; set; } = new List<VehicleDto>();
        public ICollection<int> VehicleIdList { get; set; } = new List<int>();
    }
}
