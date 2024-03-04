using AutoService.Data.DTO.ClientData;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.UserData;
using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.Entities.ClientData
{
    public class Client : User
    {
        public Client()
        {

        }

        public Client(ClientDto dto)
        {

            if (dto.AppointmentIdList.Any())
            {
                Appointments = new List<Appointment>(dto.AppointmentIdList.Count);
                foreach (AppointmentDto appointmentDto in dto.Appointments)
                {
                    Appointment Appointment = new Appointment(appointmentDto);

                    Appointments.Add(Appointment);
                }
            }

            if (dto.RequestIdList.Any())
            {
                Requests = new List<Request>(dto.RequestIdList.Count);
                foreach (RequestDto requestDto in dto.Requests)
                {
                    Request request = new Request(requestDto);

                    Requests.Add(request);
                }
            }

            if (dto.VehicleIdList.Any())
            {
                Vehicles = new List<Vehicle>(dto.VehicleIdList.Count);
                foreach (VehicleDto vehicleDto in dto.Vehicles)
                {
                    Vehicle Vehicle = new Vehicle(vehicleDto);

                    Vehicles.Add(Vehicle);
                }
            }
        }
        public ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
        public ICollection<Request> Requests { get; set; } = new List<Request>();
        public ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();

    }
}
