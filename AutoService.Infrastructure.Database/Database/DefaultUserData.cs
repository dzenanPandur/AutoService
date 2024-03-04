using AutoService.Data.Entities.UserData;

namespace AutoService.Data.Database
{
    public class DefaultUserData
    {
        public static IEnumerable<User> Users
        {
            get => new List<User>() {
                new User
                {
                    Id = Guid.Parse("B8396F1D-A29A-4856-A4C1-1312DC97A4A1"),
                    CreatedDate = DateTime.Parse("2024-02-07 17:26:40.8999869"),
                    ModifiedDate = DateTime.Parse("2024-02-07 17:26:40.8999930"),
                    Active = true,
                    FirstName = "Employee",
                    LastName = "User",
                    Gender = (Enums.Gender)1,
                    City = "Mostar",
                    Address = "Ulica 2",
                    PostalCode = 88104,
                    BirthDate = DateTime.Parse("2000-01-11 16:22:29.9610000"),
                    RoleId = Guid.Parse("9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84"),
                    UserName = "EMPLOYEE",
                    NormalizedUserName = "EMPLOYEE",
                    Email = "employee@employee.com",
                    NormalizedEmail = "EMPLOYEE@EMPLOYEE.COM",
                    EmailConfirmed = false,
                    PasswordHash = "AQAAAAIAAYagAAAAEEIHvjeCGSTaZfqUVK9IC/ONuj5fJj5vKIhHnJkXRWgMCEspYS9/+gr3DBICkveXKg==",
                    SecurityStamp = "2bb56497-5c49-4c01-8bc7-e2df21ef5d53",
                    ConcurrencyStamp = "97e229af-2604-4b7c-b579-d44e43b88576",
                    PhoneNumber = "123456789",
                    PhoneNumberConfirmed = false,
                    TwoFactorEnabled = false,
                    LockoutEnd = null,
                    LockoutEnabled = false,
                    AccessFailedCount = 0
                },
                new User
                {
                    Id = Guid.Parse("F760EE5C-435B-4875-91A5-21A6A554513B"),
                    CreatedDate = DateTime.Parse("2024-02-07 17:24:53.4221253"),
                    ModifiedDate = DateTime.Parse("2024-02-07 17:24:53.4221765"),
                    Active = true,
                    FirstName = "Admin",
                    LastName = "User",
                    Gender = (Enums.Gender)1,
                    City = "Mostar",
                    Address = "Ulica 1",
                    PostalCode = 88000,
                    BirthDate = DateTime.Parse("2000-01-01 16:22:29.9610000"),
                    RoleId = Guid.Parse("B907AE86-1B23-4A25-85C7-0C651F5E1D3D"),
                    UserName = "Admin",
                    NormalizedUserName = "ADMIN",
                    Email = "admin@admin.com",
                    NormalizedEmail = "ADMIN@ADMIN.COM",
                    EmailConfirmed = false,
                    PasswordHash = "AQAAAAIAAYagAAAAEI9PHasKoFp5DwWoGI8pTvKMeEUkZzfCkdtjIVgv1IWGNUMP9gHa01RFqELzQq5isw==",
                    SecurityStamp = "76cbb512-37af-4f7a-aef4-4b52eb2c7618",
                    ConcurrencyStamp = "2ee39f74-519d-400f-bb89-c937f284b676",
                    PhoneNumber = "123456789",
                    PhoneNumberConfirmed = false,
                    TwoFactorEnabled = false,
                    LockoutEnd = null,
                    LockoutEnabled = false,
                    AccessFailedCount = 0
                },
                new User
                {
                    Id = Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    CreatedDate = DateTime.Parse("2024-02-07 17:27:27.3310607"),
                    ModifiedDate = DateTime.Parse("2024-02-07 17:27:27.3310637"),
                    Active = true,
                    FirstName = "Client",
                    LastName = "User",
                    Gender = (Enums.Gender)2,
                    City = "Sarajevo",
                    Address = "Ulica 3",
                    PostalCode = 88104,
                    BirthDate = DateTime.Parse("1998-01-04 16:22:29.9610000"),
                    RoleId = Guid.Parse("C6C0E6D5-1A11-4B25-96A2-1989E24A2D6D"),
                    UserName = "Client",
                    NormalizedUserName = "CLIENT",
                    Email = "client@client.com",
                    NormalizedEmail = "CLIENT@CLIENT.COM",
                    EmailConfirmed = false,
                    PasswordHash = "AQAAAAIAAYagAAAAEIPOmlsV57rPJlEsDCfu4rsP2GBDN7KXIcFymvHL2ZLzlyCbzIn+LGx6DSCe6BV2og==",
                    SecurityStamp = "f5f9fa28-8f00-45a5-b3d9-e0921a1a104d",
                    ConcurrencyStamp = "650492b3-5975-4a30-b796-b27c56a065a3",
                    PhoneNumber = "123456789",
                    PhoneNumberConfirmed = false,
                    TwoFactorEnabled = false,
                    LockoutEnd = null,
                    LockoutEnabled = false,
                    AccessFailedCount = 0
                }
            };
        }
    }
}
