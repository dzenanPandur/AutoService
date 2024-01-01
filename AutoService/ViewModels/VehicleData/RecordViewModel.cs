using AutoService.Data.DTO.VehicleData;

namespace AutoService.ViewModels.VehicleData
{
    public class RecordViewModel : RecordDto
    {
        public RecordViewModel() 
        {
        
        }

        public RecordViewModel(RecordDto dto)
        {
            Id = dto.Id;
            Date = dto.Date;
            MileageAtTimeOfService = dto.MileageAtTimeOfService;
            Cost = dto.Cost;
            Notes = dto.Notes;
            ServiceIdList = dto.ServiceIdList;
            VehicleId = dto.VehicleId;
        }


    }
}
