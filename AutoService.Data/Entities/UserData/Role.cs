using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.UserData
{
    public class Role : IdentityRole<Guid>
    {
        [Key]
        public Guid Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Users { get; set; } = new List<User>();
    }
}
