using AutoService.Data.DTO.UserData;
using AutoService.Data.Enums;

namespace AutoService.ViewModels.UserData
{
    public class UserViewModel : UserDto
    {
        public UserViewModel() {

        }

        public UserViewModel(UserDto dto) {
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

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool? Active { get; set; }
        public Gender Gender { get; set; }
        public string City { get; set; }
        public string? Address { get; set; }
        public int? PostalCode { get; set; }
        public DateTime BirthDate { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string RoleName { get; set; }
    }
}
