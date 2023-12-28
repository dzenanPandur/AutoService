using AutoService.Data.DTO;
using AutoService.Data.Enums;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.UserData
{
    public class User : IdentityUser<Guid>
    {
        [Key]
        public Guid Id { get; set; }
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
    }
}
