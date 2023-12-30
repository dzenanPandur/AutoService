using AutoService.Data.DTO;
using AutoService.Data.DTO.UserData;
using AutoService.Data.Enums;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.UserData
{
    public class User : IdentityUser<Guid>
    {
        public User() {
            
        }

        public User(UserDto dto)
        {
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
            RoleId = dto.RoleId;

            if (dto.Role is not null)
            {
                Role = new Role(dto.Role);
            }
        }

        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool? Active { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Gender Gender { get; set; }
        public string City { get; set; }
        public string? Address { get; set; }
        public int? PostalCode { get; set; }
        public DateTime BirthDate { get; set; }
        public Role Role { get; set; }
        public Guid RoleId { get; set; }
        public override string UserName
        {
            get => base.UserName;
            set => base.UserName = value ?? throw new ArgumentNullException(nameof(value));
        }

        public override string NormalizedUserName
        {
            get => base.NormalizedUserName;
            set => base.NormalizedUserName = value ?? throw new ArgumentNullException(nameof(value));
        }

        public override string Email
        {
            get => base.Email;
            set => base.Email = value ?? throw new ArgumentNullException(nameof(value));
        }

        public override string NormalizedEmail
        {
            get => base.NormalizedEmail;
            set => base.NormalizedEmail = value ?? throw new ArgumentNullException(nameof(value));
        }
    }
}
