using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class add_active : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "isActive",
                table: "VehicleTypes",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isActive",
                table: "VehicleFuelTypes",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isActive",
                table: "TransmissionTypes",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isActive",
                table: "Categories",
                type: "bit",
                nullable: false,
                defaultValue: false);

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
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isActive",
                table: "VehicleTypes");

            migrationBuilder.DropColumn(
                name: "isActive",
                table: "VehicleFuelTypes");

            migrationBuilder.DropColumn(
                name: "isActive",
                table: "TransmissionTypes");

            migrationBuilder.DropColumn(
                name: "isActive",
                table: "Categories");

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 20, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2709));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 19, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2712));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 5, 21, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2714));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 5, 22, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2716));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2693), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2693) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2696), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2696) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2698), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2698) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2699), new DateTime(2024, 5, 14, 20, 20, 26, 405, DateTimeKind.Utc).AddTicks(2700) });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 14, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2617));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 14, 22, 20, 26, 405, DateTimeKind.Local).AddTicks(2638));
        }
    }
}
