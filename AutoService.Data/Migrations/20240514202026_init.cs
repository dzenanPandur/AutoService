using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "dbo");

            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Role",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    NormalizedName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Role", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "TransmissionTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TransmissionTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "VehicleFuelTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VehicleFuelTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "VehicleTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VehicleTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Services",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: true),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    CategoryId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Services", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Services_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "RoleClaim",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoleClaim", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RoleClaim_Role_RoleId",
                        column: x => x.RoleId,
                        principalSchema: "dbo",
                        principalTable: "Role",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "User",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Active = table.Column<bool>(type: "bit", nullable: true),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    City = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PostalCode = table.Column<int>(type: "int", nullable: true),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    NormalizedUserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    NormalizedEmail = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    Discriminator = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EmailConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SecurityStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "bit", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "datetimeoffset", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "bit", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_User", x => x.Id);
                    table.ForeignKey(
                        name: "FK_User_Role_RoleId",
                        column: x => x.RoleId,
                        principalSchema: "dbo",
                        principalTable: "Role",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Appointments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsOccupied = table.Column<bool>(type: "bit", nullable: true),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ClientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RequestId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Appointments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Appointments_User_ClientId",
                        column: x => x.ClientId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_Role_RoleId",
                        column: x => x.RoleId,
                        principalSchema: "dbo",
                        principalTable: "Role",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_User_UserId",
                        column: x => x.UserId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserClaim",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserClaim", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserClaim_User_UserId",
                        column: x => x.UserId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserLogin",
                schema: "dbo",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderKey = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserLogin", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_UserLogin_User_UserId",
                        column: x => x.UserId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserToken",
                schema: "dbo",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Value = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserToken", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_UserToken_User_UserId",
                        column: x => x.UserId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Vehicles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Make = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Model = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Vin = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ManufactureYear = table.Column<int>(type: "int", nullable: true),
                    Mileage = table.Column<int>(type: "int", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false),
                    isArchived = table.Column<bool>(type: "bit", nullable: false),
                    FuelTypeId = table.Column<int>(type: "int", nullable: true),
                    VehicleTypeId = table.Column<int>(type: "int", nullable: true),
                    TransmissionTypeId = table.Column<int>(type: "int", nullable: true),
                    ClientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Vehicles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Vehicles_TransmissionTypes_TransmissionTypeId",
                        column: x => x.TransmissionTypeId,
                        principalTable: "TransmissionTypes",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Vehicles_User_ClientId",
                        column: x => x.ClientId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Vehicles_VehicleFuelTypes_FuelTypeId",
                        column: x => x.FuelTypeId,
                        principalTable: "VehicleFuelTypes",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Vehicles_VehicleTypes_VehicleTypeId",
                        column: x => x.VehicleTypeId,
                        principalTable: "VehicleTypes",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Request",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Status = table.Column<int>(type: "int", nullable: false),
                    DateRequested = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DateCompleted = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CustomRequest = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TotalCost = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    AppointmentId = table.Column<int>(type: "int", nullable: true),
                    ClientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    VehicleId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Request", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Request_Appointments_AppointmentId",
                        column: x => x.AppointmentId,
                        principalTable: "Appointments",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Request_User_ClientId",
                        column: x => x.ClientId,
                        principalSchema: "dbo",
                        principalTable: "User",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Request_Vehicles_VehicleId",
                        column: x => x.VehicleId,
                        principalTable: "Vehicles",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "VehicleServiceRecords",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: true),
                    MileageAtTimeOfService = table.Column<int>(type: "int", nullable: true),
                    Cost = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    VehicleId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VehicleServiceRecords", x => x.Id);
                    table.ForeignKey(
                        name: "FK_VehicleServiceRecords_Vehicles_VehicleId",
                        column: x => x.VehicleId,
                        principalTable: "Vehicles",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ServiceRequest",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ServiceId = table.Column<int>(type: "int", nullable: false),
                    RequestId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServiceRequest", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ServiceRequest_Request_RequestId",
                        column: x => x.RequestId,
                        principalTable: "Request",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ServiceRequest_Services_ServiceId",
                        column: x => x.ServiceId,
                        principalTable: "Services",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ServicesPerformed",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecordId = table.Column<int>(type: "int", nullable: false),
                    ServiceId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServicesPerformed", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ServicesPerformed_Services_ServiceId",
                        column: x => x.ServiceId,
                        principalTable: "Services",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ServicesPerformed_VehicleServiceRecords_RecordId",
                        column: x => x.RecordId,
                        principalTable: "VehicleServiceRecords",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });


            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Checks" },
                    { 2, "Changes" },
                    { 3, "Tuning" }
                });

            migrationBuilder.InsertData(
                schema: "dbo",
                table: "Role",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { new Guid("9f4392a8-80bc-4c4f-9a6a-8d2c6c875f84"), null, "Employee", null },
                    { new Guid("b907ae86-1b23-4a25-85c7-0c651f5e1d3d"), null, "Admin", null },
                    { new Guid("c6c0e6d5-1a11-4b25-96a2-1989e24a2d6d"), null, "Client", null }
                });

            migrationBuilder.InsertData(
                table: "TransmissionTypes",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Manual" },
                    { 2, "Automatic" }
                });

            migrationBuilder.InsertData(
                table: "VehicleFuelTypes",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Petrol" },
                    { 2, "Diesel" },
                    { 3, "Electric" },
                    { 4, "Hybrid" }
                });

            migrationBuilder.InsertData(
                table: "VehicleTypes",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Sedan" },
                    { 2, "Hatchback" },
                    { 3, "SUV" },
                    { 4, "Coupe" },
                    { 5, "Minivan" },
                    { 6, "Convertible" },
                    { 7, "Station wagon" },
                    { 8, "Crossover" },
                    { 9, "Other" }
                });

            migrationBuilder.InsertData(
                table: "Services",
                columns: new[] { "Id", "CategoryId", "IsActive", "Name", "Price" },
                values: new object[,]
                {
                    { 1, 2, true, "Change oil", 80m },
                    { 2, 2, true, "Change brakes", 250m },
                    { 3, 2, true, "Change freon", 80m },
                    { 4, 2, true, "Change lights", 35m },
                    { 5, 1, true, "Check oil", 5m },
                    { 6, 1, true, "Check brakes", 60m },
                    { 7, 1, true, "Check lights", 5m },
                    { 8, 1, true, "Check freon", 10m },
                    { 9, 3, true, "ECU Tune", 300m }
                });

            migrationBuilder.InsertData(
                schema: "dbo",
                table: "User",
                columns: new[] { "Id", "AccessFailedCount", "Active", "Address", "BirthDate", "City", "ConcurrencyStamp", "CreatedDate", "Discriminator", "Email", "EmailConfirmed", "FirstName", "Gender", "LastName", "LockoutEnabled", "LockoutEnd", "ModifiedDate", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "PostalCode", "RoleId", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), 0, true, "Ulica 3", new DateTime(1998, 1, 4, 16, 22, 29, 961, DateTimeKind.Unspecified), "Sarajevo", "650492b3-5975-4a30-b796-b27c56a065a3", new DateTime(2024, 2, 7, 17, 27, 27, 331, DateTimeKind.Unspecified).AddTicks(607), "User", "client@client.com", false, "Client", 2, "User", false, null, new DateTime(2024, 2, 7, 17, 27, 27, 331, DateTimeKind.Unspecified).AddTicks(637), "CLIENT@CLIENT.COM", "CLIENT", "AQAAAAIAAYagAAAAEIPOmlsV57rPJlEsDCfu4rsP2GBDN7KXIcFymvHL2ZLzlyCbzIn+LGx6DSCe6BV2og==", "123456789", false, 88104, new Guid("c6c0e6d5-1a11-4b25-96a2-1989e24a2d6d"), "f5f9fa28-8f00-45a5-b3d9-e0921a1a104d", false, "Client" },
                    { new Guid("b8396f1d-a29a-4856-a4c1-1312dc97a4a1"), 0, true, "Ulica 2", new DateTime(2000, 1, 11, 16, 22, 29, 961, DateTimeKind.Unspecified), "Mostar", "97e229af-2604-4b7c-b579-d44e43b88576", new DateTime(2024, 2, 7, 17, 26, 40, 899, DateTimeKind.Unspecified).AddTicks(9869), "User", "employee@employee.com", false, "Employee", 1, "User", false, null, new DateTime(2024, 2, 7, 17, 26, 40, 899, DateTimeKind.Unspecified).AddTicks(9930), "EMPLOYEE@EMPLOYEE.COM", "EMPLOYEE", "AQAAAAIAAYagAAAAEEIHvjeCGSTaZfqUVK9IC/ONuj5fJj5vKIhHnJkXRWgMCEspYS9/+gr3DBICkveXKg==", "123456789", false, 88104, new Guid("9f4392a8-80bc-4c4f-9a6a-8d2c6c875f84"), "2bb56497-5c49-4c01-8bc7-e2df21ef5d53", false, "EMPLOYEE" },
                    { new Guid("f760ee5c-435b-4875-91a5-21a6a554513b"), 0, true, "Ulica 1", new DateTime(2000, 1, 1, 16, 22, 29, 961, DateTimeKind.Unspecified), "Mostar", "2ee39f74-519d-400f-bb89-c937f284b676", new DateTime(2024, 2, 7, 17, 24, 53, 422, DateTimeKind.Unspecified).AddTicks(1253), "User", "admin@admin.com", false, "Admin", 1, "User", false, null, new DateTime(2024, 2, 7, 17, 24, 53, 422, DateTimeKind.Unspecified).AddTicks(1765), "ADMIN@ADMIN.COM", "ADMIN", "AQAAAAIAAYagAAAAEI9PHasKoFp5DwWoGI8pTvKMeEUkZzfCkdtjIVgv1IWGNUMP9gHa01RFqELzQq5isw==", "123456789", false, 88000, new Guid("b907ae86-1b23-4a25-85c7-0c651f5e1d3d"), "76cbb512-37af-4f7a-aef4-4b52eb2c7618", false, "Admin" }
                });
            migrationBuilder.InsertData(
                table: "Appointments",
                columns: new[] { "Id", "ClientId", "Date", "IsOccupied", "RequestId" },
                values: new object[,]
                {
                    { 1, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 5, 20, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2709), true, 1 },
                    { 2, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 5, 19, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2712), false, 2 },
                    { 3, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 5, 21, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2714), true, 3 },
                    { 4, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 5, 22, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2716), false, 4 }
                });

            migrationBuilder.InsertData(
                table: "Vehicles",
                columns: new[] { "Id", "ClientId", "FuelTypeId", "Make", "ManufactureYear", "Mileage", "Model", "Status", "TransmissionTypeId", "VehicleTypeId", "Vin", "isArchived" },
                values: new object[,]
                {
                    { 1, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), 2, "Peugeot", 2016, 195123, "308", 2, 1, 2, "1231AKHJKHJ1213JH", false },
                    { 2, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), 1, "Toyota", 2008, 18590, "Yaris", 4, 1, 2, "12151AKGHEQRH15121JH", false }
                });

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Message", "Status", "TotalCost", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change tires", new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2693), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2693), " ", 2, 600m, 1 },
                    { 2, 2, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change window", new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2696), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2696), " ", 6, 450m, 1 },
                    { 3, 3, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change bumper", new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2698), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2698), " ", 7, 400m, 1 },
                    { 4, 4, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change rims", new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2699), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2700), " ", 4, 700m, 2 }
                });

            migrationBuilder.InsertData(
                table: "VehicleServiceRecords",
                columns: new[] { "Id", "Cost", "Date", "MileageAtTimeOfService", "Notes", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1500m, new DateTime(2024, 5, 14, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2617), 185100, "Found broken light", 1 },
                    { 2, 500m, new DateTime(2024, 5, 14, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2638), 17800, "", 2 }
                });

            migrationBuilder.InsertData(
                table: "ServiceRequest",
                columns: new[] { "Id", "RequestId", "ServiceId" },
                values: new object[,]
                {
                    { 1, 4, 1 },
                    { 2, 3, 3 },
                    { 3, 3, 2 },
                    { 4, 3, 1 },
                    { 5, 2, 4 },
                    { 6, 2, 3 },
                    { 7, 1, 2 },
                    { 8, 1, 1 }
                });

            migrationBuilder.InsertData(
                table: "ServicesPerformed",
                columns: new[] { "Id", "RecordId", "ServiceId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 1, 2 },
                    { 3, 1, 3 },
                    { 4, 1, 4 },
                    { 5, 2, 3 },
                    { 6, 2, 1 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_ClientId",
                table: "Appointments",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Request_AppointmentId",
                table: "Request",
                column: "AppointmentId",
                unique: true,
                filter: "[AppointmentId] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Request_ClientId",
                table: "Request",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Request_VehicleId",
                table: "Request",
                column: "VehicleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                schema: "dbo",
                table: "Role",
                column: "NormalizedName",
                unique: true,
                filter: "[NormalizedName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_RoleClaim_RoleId",
                schema: "dbo",
                table: "RoleClaim",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceRequest_RequestId",
                table: "ServiceRequest",
                column: "RequestId");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceRequest_ServiceId",
                table: "ServiceRequest",
                column: "ServiceId");

            migrationBuilder.CreateIndex(
                name: "IX_Services_CategoryId",
                table: "Services",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_ServicesPerformed_RecordId",
                table: "ServicesPerformed",
                column: "RecordId");

            migrationBuilder.CreateIndex(
                name: "IX_ServicesPerformed_ServiceId",
                table: "ServicesPerformed",
                column: "ServiceId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                schema: "dbo",
                table: "User",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "IX_User_RoleId",
                schema: "dbo",
                table: "User",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                schema: "dbo",
                table: "User",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserClaim_UserId",
                schema: "dbo",
                table: "UserClaim",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserLogin_UserId",
                schema: "dbo",
                table: "UserLogin",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Vehicles_ClientId",
                table: "Vehicles",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Vehicles_FuelTypeId",
                table: "Vehicles",
                column: "FuelTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Vehicles_TransmissionTypeId",
                table: "Vehicles",
                column: "TransmissionTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Vehicles_VehicleTypeId",
                table: "Vehicles",
                column: "VehicleTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_VehicleServiceRecords_VehicleId",
                table: "VehicleServiceRecords",
                column: "VehicleId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "RoleClaim",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "ServiceRequest");

            migrationBuilder.DropTable(
                name: "ServicesPerformed");

            migrationBuilder.DropTable(
                name: "UserClaim",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "UserLogin",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "UserToken",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "Request");

            migrationBuilder.DropTable(
                name: "Services");

            migrationBuilder.DropTable(
                name: "VehicleServiceRecords");

            migrationBuilder.DropTable(
                name: "Appointments");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropTable(
                name: "Vehicles");

            migrationBuilder.DropTable(
                name: "TransmissionTypes");

            migrationBuilder.DropTable(
                name: "User",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "VehicleFuelTypes");

            migrationBuilder.DropTable(
                name: "VehicleTypes");

            migrationBuilder.DropTable(
                name: "Role",
                schema: "dbo");
        }
    }
}
