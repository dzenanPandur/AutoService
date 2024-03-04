using AutoService.Data.Entities.UserData;
using Microsoft.AspNetCore.Identity;

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

        public static IEnumerable<IdentityUserRole<Guid>> UserRoles
        {
            get => new List<IdentityUserRole<Guid>>() {
                new IdentityUserRole<Guid>
                {
                    UserId = Guid.Parse("F760EE5C-435B-4875-91A5-21A6A554513B"),
                    RoleId = Guid.Parse("B907AE86-1B23-4A25-85C7-0C651F5E1D3D")
                },
                new IdentityUserRole<Guid>
                {
                    UserId = Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    RoleId = Guid.Parse("C6C0E6D5-1A11-4B25-96A2-1989E24A2D6D")
                },
                new IdentityUserRole<Guid>
                {
                    UserId = Guid.Parse("B8396F1D-A29A-4856-A4C1-1312DC97A4A1"),
                    RoleId = Guid.Parse("9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84")
                }
            };
        }
    }
}

