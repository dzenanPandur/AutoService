using AutoService.Data.Entities.UserData;

namespace AutoService.Data.Database
{
    public class DefaultRoleData
    {
        public static IEnumerable<Role> Roles
        {
            get => new List<Role>() {
                new Role
                {
                    Id = Guid.Parse("B907AE86-1B23-4A25-85C7-0C651F5E1D3D"),
                    Name = "Admin"
                },
                new Role
                {
                    Id = Guid.Parse("9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84"),
                    Name = "Employee"
                },
                new Role
                {
                    Id = Guid.Parse("C6C0E6D5-1A11-4B25-96A2-1989E24A2D6D"),
                    Name = "Client"
                }
            };
        }


    }
}

