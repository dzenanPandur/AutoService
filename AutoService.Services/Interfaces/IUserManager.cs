using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;

namespace AutoService.Services.Interfaces
{
    public interface IUserManager
    {
        public Task<UserDto> GetByUsernameOrEmail(string username, string email);
        public Task<UserDto> GetByUsername(string username);
        public Task<List<UserDto>> GetAllUsers();
        public Task<int> CreateUser(UserDto dto);
    }
}
