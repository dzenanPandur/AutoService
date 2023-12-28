using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.DTO.VehicleData
{
    public class VehicleServiceRecordDto
    {
        public VehicleServiceRecordDto()
        {

        }

        public VehicleServiceRecordDto(VehicleServiceRecord vehicleServiceRecord)
        {
            Id = vehicleServiceRecord.Id;
            Date = vehicleServiceRecord.Date;
            MileageAtTimeOfService = vehicleServiceRecord.MileageAtTimeOfService;
            Cost = vehicleServiceRecord.Cost;
            Notes = vehicleServiceRecord.Notes;
            VehicleId = vehicleServiceRecord.VehicleId;

            if (vehicleServiceRecord.Services is not null)
            {
                Services = new List<ServiceDto>(
                    vehicleServiceRecord.Services
                        .Select(s => new ServiceDto(s))
                        .ToList());

                ServiceIdList = vehicleServiceRecord.Services
                    .Select(s => s.Id)
                    .ToList();
            }
        }
        public int Id { get; set; }
        public DateTime? Date { get; set; }
        public int? MileageAtTimeOfService { get; set; }
        public decimal? Cost { get; set; }
        public string? Notes { get; set; }
        public Vehicle? Vehicle { get; set; }
        public int? VehicleId { get; set; }
        public ICollection<ServiceDto> Services { get; set; } = new List<ServiceDto>();
        public ICollection<int> ServiceIdList { get; set; } = new List<int>();
    }
}
