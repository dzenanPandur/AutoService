using AutoService.Data.DTO.ServiceData;

namespace AutoService.Services.Interfaces
{
    public interface IRequestManager
    {
        public Task<RequestDto> GetRequest(int id);
        public Task<IEnumerable<RequestDto>> GetAllRequests();
        public Task<int> CreateRequest(RequestDto dto);
        public Task<RequestDto> UpdateRequest(RequestDto dto);
        public Task<int> DeleteRequest(int id);
    }
}
