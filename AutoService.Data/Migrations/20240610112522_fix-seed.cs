using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class fixseed : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                table: "Categories",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: true);

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
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEGQ74H878UZXZ2qrO3PGUCmbDkeR0pVC/YQ0BJQHFv50ks5DsM3WDpIZiB85F9hpRg==");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("b8396f1d-a29a-4856-a4c1-1312dc97a4a1"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEGQ74H878UZXZ2qrO3PGUCmbDkeR0pVC/YQ0BJQHFv50ks5DsM3WDpIZiB85F9hpRg==");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("f760ee5c-435b-4875-91a5-21a6a554513b"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEGQ74H878UZXZ2qrO3PGUCmbDkeR0pVC/YQ0BJQHFv50ks5DsM3WDpIZiB85F9hpRg==");

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 4,
                column: "isActive",
                value: true);

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

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 4,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 5,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 6,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 7,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 8,
                column: "isActive",
                value: true);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 9,
                column: "isActive",
                value: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 16, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(7003));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 15, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(7008));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 6, 17, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(7010));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 6, 18, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(7013));

            migrationBuilder.UpdateData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6985), new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6986) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6989), new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6989) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6992), new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6992) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6994), new DateTime(2024, 6, 10, 11, 22, 59, 527, DateTimeKind.Utc).AddTicks(6994) });

            migrationBuilder.UpdateData(
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEIPOmlsV57rPJlEsDCfu4rsP2GBDN7KXIcFymvHL2ZLzlyCbzIn+LGx6DSCe6BV2og==");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("b8396f1d-a29a-4856-a4c1-1312dc97a4a1"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEEIHvjeCGSTaZfqUVK9IC/ONuj5fJj5vKIhHnJkXRWgMCEspYS9/+gr3DBICkveXKg==");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("f760ee5c-435b-4875-91a5-21a6a554513b"),
                column: "PasswordHash",
                value: "AQAAAAIAAYagAAAAEI9PHasKoFp5DwWoGI8pTvKMeEUkZzfCkdtjIVgv1IWGNUMP9gHa01RFqELzQq5isw==");

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 4,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 10, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(6885));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 10, 13, 22, 59, 527, DateTimeKind.Local).AddTicks(6910));

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 1,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 2,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 3,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 4,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 5,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 6,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 7,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 8,
                column: "isActive",
                value: false);

            migrationBuilder.UpdateData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 9,
                column: "isActive",
                value: false);
        }
    }
}
