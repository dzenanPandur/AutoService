using AutoService.Data.Entities.UserData;
using System.Text.Json.Serialization;

namespace AutoService.Data.DTO.UserData
{
    public class RoleDto
    {
        public RoleDto() {
        
        }
        public RoleDto(Role role) {
            Id = role.Id;
            Name = role.Name;
        }
        [JsonIgnore]
        public Guid Id { get; set; }
        public string Name { get; set; }
    }
}
