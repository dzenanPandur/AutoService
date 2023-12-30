using AutoService.Data.DTO.UserData;

namespace AutoService.Services.Interfaces
{
    public interface IRoleManager
    {
        public Task<RoleDto> GetRoleById(Guid id);
        public Task<RoleDto> GetRoleByName(string name);
    }
}
