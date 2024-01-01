using AutoService.Data.DTO.ServiceData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Enums;

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
    }
}
