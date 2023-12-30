using AutoService.Data.DTO.UserData;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.UserData
{
    public class Role : IdentityRole<Guid>
    {
        public Role() { }

        public Role (RoleDto dto) {
            Id = dto.Id;
            Name = dto.Name;
        }

        [Key]
        public Guid Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Users { get; set; } = new List<User>();
    }
}
