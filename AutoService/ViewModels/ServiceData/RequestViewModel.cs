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
            DateRequested = dto.DateRequested;
            DateCompleted = dto.DateCompleted;
            CustomRequest = dto.CustomRequest;
            ServiceIdList = dto.ServiceIdList;

        }

        public string Status { get; set; }
        public string VehicleName { get; set; }
        public string ClientName { get; set; }
    }
}
