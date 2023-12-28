using AutoService.Data.DTO.ClientData;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Data.Enums;

namespace AutoService.Data.DTO.VehicleData
{
    public class VehicleDto
    {
        public VehicleDto() { }

        public VehicleDto(Vehicle vehicle)
        {
            Id = vehicle.Id;
            Make = vehicle.Make;
            Model = vehicle.Model;
            Vin = vehicle.Vin;
            ManufactureYear = vehicle.ManufactureYear;
            Mileage = vehicle.Mileage;
            Status = vehicle.Status;
            ClientId = vehicle.ClientId;
            FuelTypeId = vehicle.FuelTypeId;
            TransmissionTypeId = vehicle.TransmissionTypeId;
            VehicleTypeId = vehicle.VehicleTypeId;

            if (vehicle.FuelType is not null)
            {
                FuelType = new VehicleFuelTypeDto(vehicle.FuelType);
            }

            if (vehicle.TransmissionType is not null)
            {
                TransmissionType = new TransmissionTypeDto(vehicle.TransmissionType);
            }

            if (vehicle.VehicleType is not null)
            {
                VehicleType = new VehicleTypeDto(vehicle.VehicleType);
            }

            if (vehicle.Records is not null)
            {
                Records = new List<VehicleServiceRecordDto>(
                    vehicle.Records
                    .Select(r => new VehicleServiceRecordDto(r))
                    .ToList());

                RecordIdList = vehicle.Records
                    .Select(r => r.Id)
                    .ToList();
            }
        }

        public int Id { get; set; }
        public string Make { get; set; } = null!;
        public string Model { get; set; } = null!;
        public string Vin { get; set; } = null!;
        public int? ManufactureYear { get; set; }
        public int? Mileage { get; set; }
        public Status Status { get; set; }
        public VehicleFuelTypeDto? FuelType { get; set; }
        public int? FuelTypeId { get; set; }
        public ICollection<RequestDto> Requests { get; set; } = new List<RequestDto>();
        public TransmissionTypeDto? TransmissionType { get; set; }
        public int? TransmissionTypeId { get; set; }
        public ClientDto Client { get; set; }
        public Guid ClientId { get; set; }
        public VehicleTypeDto? VehicleType { get; set; }
        public int? VehicleTypeId { get; set; }
        public ICollection<VehicleServiceRecordDto> Records { get; set; } = new List<VehicleServiceRecordDto>();
        public ICollection<int> RecordIdList { get; set; } = new List<int>();
    }
}
