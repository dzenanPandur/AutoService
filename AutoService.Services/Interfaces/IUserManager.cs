using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;

namespace AutoService.Services.Interfaces
{
    public interface IUserManager
    {
        public Task<UserDto> GetByUsernameOrEmail(string username, string email);
        public Task<UserDto> GetByUsername(string username);
        public Task<UserDto> GetUserById(Guid id);
        public Task<List<UserDto>> GetAllUsers();
        public Task<int> CreateUser(UserDto dto);
        public Task<User> UpdateUser(UserDto dto);
        public Task<int> DeleteUser(Guid id);
    }
}
