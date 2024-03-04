using AutoService.Data.DTO.ClientData;
using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Data.Enums;
using System.Text.Json.Serialization;

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
                Records = new List<RecordDto>(
                    vehicle.Records
                    .Select(r => new RecordDto(r))
                    .ToList());

                RecordIdList = vehicle.Records
                    .Select(r => r.Id)
                    .ToList();
            }
        }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int Id { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public string Vin { get; set; }
        public int? ManufactureYear { get; set; }
        public int? Mileage { get; set; }
        public Status Status { get; set; }
        [JsonIgnore]
        public VehicleFuelTypeDto? FuelType { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int? FuelTypeId { get; set; }
        [JsonIgnore]
        public ICollection<RequestDto> Requests { get; set; } = new List<RequestDto>();
        [JsonIgnore]
        public TransmissionTypeDto? TransmissionType { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int? TransmissionTypeId { get; set; }
        [JsonIgnore]
        public ClientDto? Client { get; set; }
        [JsonIgnore]
        public Guid ClientId { get; set; }
        [JsonIgnore]
        public VehicleTypeDto? VehicleType { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int? VehicleTypeId { get; set; }
        [JsonIgnore]
        public ICollection<RecordDto> Records { get; set; } = new List<RecordDto>();
        [JsonIgnore]
        public ICollection<int> RecordIdList { get; set; } = new List<int>();
    }
}
