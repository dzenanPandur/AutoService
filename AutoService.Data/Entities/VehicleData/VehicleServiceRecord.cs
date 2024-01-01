using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Entities.ServiceData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.VehicleData;

public class VehicleServiceRecord
{
    public VehicleServiceRecord()
    {

    }

    public VehicleServiceRecord(RecordDto dto)
    {
        Id = dto.Id;
        Date = dto.Date;
        MileageAtTimeOfService = dto.MileageAtTimeOfService;
        Cost = dto.Cost;
        Notes = dto.Notes;
        VehicleId = dto.VehicleId;

        if (dto.ServiceIdList.Any())
        {
            ServicesPerformeds = new List<ServicesPerformed>(dto.ServiceIdList.Count);
            foreach (int serviceId in dto.ServiceIdList)
            {
                ServicesPerformed servicePerformed = new()
                {
                    RecordId = Id,
                    ServiceId = serviceId
                };

                ServicesPerformeds.Add(servicePerformed);
            }
        }
    }

    [Key]
    public int Id { get; set; }
    public DateTime? Date { get; set; }
    public int? MileageAtTimeOfService { get; set; }
    public decimal? Cost { get; set; }
    public string? Notes { get; set; }
    public Vehicle? Vehicle { get; set; }
    public int? VehicleId { get; set; }
    public ICollection<Service> Services { get; set; } = new List<Service>();
    public ICollection<ServicesPerformed> ServicesPerformeds { get; set; } = new List<ServicesPerformed>();
}
