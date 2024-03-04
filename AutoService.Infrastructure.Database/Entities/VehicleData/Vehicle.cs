using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ClientData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Enums;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.VehicleData;

public class Vehicle
{
    public Vehicle()
    {

    }

    public Vehicle(VehicleDto dto)
    {
        Id = dto.Id;
        Make = dto.Make;
        Model = dto.Model;
        Vin = dto.Vin;
        ManufactureYear = dto.ManufactureYear;
        Mileage = dto.Mileage;
        Status = dto.Status;
        ClientId = dto.ClientId;
        FuelTypeId = dto.FuelTypeId;
        TransmissionTypeId = dto.TransmissionTypeId;
        VehicleTypeId = dto.VehicleTypeId;

        if (dto.FuelType is not null)
        {
            FuelType = new VehicleFuelType(dto.FuelType);
        }

        if (dto.TransmissionType is not null)
        {
            TransmissionType = new TransmissionType(dto.TransmissionType);
        }

        if (dto.VehicleType is not null)
        {
            VehicleType = new VehicleType(dto.VehicleType);
        }

        if (dto.RecordIdList.Any())
        {
            Records = new List<VehicleServiceRecord>(dto.RecordIdList.Count);
            foreach (RecordDto recordDto in dto.Records)
            {
                VehicleServiceRecord record = new VehicleServiceRecord(recordDto);

                Records.Add(record);
            }
        }

    }

    [Key]
    public int Id { get; set; }
    public string Make { get; set; }
    public string Model { get; set; }
    public string Vin { get; set; }
    public int? ManufactureYear { get; set; }
    public int? Mileage { get; set; }
    public Status Status { get; set; }
    public VehicleFuelType? FuelType { get; set; }
    public int? FuelTypeId { get; set; }
    public VehicleType? VehicleType { get; set; }
    public int? VehicleTypeId { get; set; }
    public TransmissionType? TransmissionType { get; set; }
    public int? TransmissionTypeId { get; set; }
    public Client Client { get; set; }
    public Guid ClientId { get; set; }
    public ICollection<VehicleServiceRecord> Records { get; set; } = new List<VehicleServiceRecord>();
    public ICollection<Request> Requests { get; set; } = new List<Request>();

}
