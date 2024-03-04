using AutoService.Data.Entities.UserData;
using AutoService.Data.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace AutoService.Data.DTO.UserData
{
    public class UserDto
    {
        public UserDto() { 

        }

        public UserDto(User user)
        {
            Id = user.Id;
            FirstName = user.FirstName;
            LastName = user.LastName;
            Active = user.Active;
            Gender = user.Gender;
            City = user.City;
            Address = user.Address;
            PostalCode = user.PostalCode;
            BirthDate = user.BirthDate;
            Email = user.Email;
            UserName = user.UserName;
            PhoneNumber = user.PhoneNumber;
            RoleId = user.RoleId;
            Password = user.PasswordHash;

            if (user.Role is not null)
            {
                Role = new RoleDto(user.Role);
            }
        }

        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public Guid Id { get; set; }
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
        [JsonIgnore]
        public RoleDto? Role { get; set; }

        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public string Password { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public string PasswordConfirm { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public Guid RoleId { get; set; }
    }
}
