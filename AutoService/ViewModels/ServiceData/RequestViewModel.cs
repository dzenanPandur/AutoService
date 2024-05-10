using AutoService.Data.DTO.ServiceData;

namespace AutoService.ViewModels.ServiceData
{
    public class RequestViewModel : RequestDto
    {
        public RequestViewModel()
        {

        }

        public RequestViewModel(RequestDto dto)
        {
            Id = dto.Id;
            Status = dto.Status.ToString();
            StatusId = (int)dto.Status;
            DateRequested = dto.DateRequested;
            DateCompleted = dto.DateCompleted;
            CustomRequest = dto.CustomRequest;
            ServiceIdList = dto.ServiceIdList;
            TotalCost = dto.TotalCost;

        }
        public int StatusId { get; set; }
        public string Status { get; set; }
        public string VehicleName { get; set; }
        public string ClientName { get; set; }
        public int? VehicleId { get; set; }
    }
}
