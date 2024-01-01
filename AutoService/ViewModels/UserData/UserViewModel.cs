using AutoService.Data.DTO.UserData;
using AutoService.Data.Enums;

namespace AutoService.ViewModels.UserData
{
    public class UserViewModel : UserDto
    {
        public UserViewModel() {

        }

        public UserViewModel(UserDto dto) {
            Id = dto.Id;
            FirstName = dto.FirstName;
            LastName = dto.LastName;
            Active = dto.Active;
            Gender = dto.Gender;
            City = dto.City;
            Address = dto.Address;
            PostalCode = dto.PostalCode;
            BirthDate = dto.BirthDate;
            Email = dto.Email;
            UserName = dto.UserName;
            PhoneNumber = dto.PhoneNumber;
            RoleName = dto.Role.Name;
        }

        public string RoleName { get; set; }
    }
}
