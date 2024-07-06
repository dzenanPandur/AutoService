using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class identityfix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "RoleClaim",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "UserClaim",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "UserLogin",
                schema: "dbo");

            migrationBuilder.DropTable(
                name: "UserToken",
                schema: "dbo");

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 7, 5, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2506));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 7, 4, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2514));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 7, 6, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2516));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 7, 7, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2518));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2485), new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2486) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2489), new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2489) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2491), new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2491) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2492), new DateTime(2024, 6, 29, 11, 43, 36, 365, DateTimeKind.Utc).AddTicks(2493) });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 29, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2106));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 29, 13, 43, 36, 365, DateTimeKind.Local).AddTicks(2131));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
                name: "RoleClaim",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
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
                name: "UserClaim",
                schema: "dbo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
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

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 16, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6772));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 15, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6776));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 6, 17, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6779));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 6, 18, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6781));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6754), new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6754) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6757), new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6758) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6760), new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6760) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6762), new DateTime(2024, 6, 10, 11, 25, 22, 119, DateTimeKind.Utc).AddTicks(6763) });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 10, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6664));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 10, 13, 25, 22, 119, DateTimeKind.Local).AddTicks(6693));

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_RoleClaim_RoleId",
                schema: "dbo",
                table: "RoleClaim",
                column: "RoleId");

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
        }
    }
}
