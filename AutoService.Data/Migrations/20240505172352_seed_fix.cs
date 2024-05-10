using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class seed_fix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 5, 19, 23, 51, 669, DateTimeKind.Local).AddTicks(2076));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 23, 51, 669, DateTimeKind.Utc).AddTicks(2079));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 5, 5, 19, 23, 51, 669, DateTimeKind.Local).AddTicks(2080));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 5, 5, 19, 23, 51, 669, DateTimeKind.Local).AddTicks(2082));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "AppointmentId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "TotalCost", "VehicleId" },
                values: new object[] { 4, "Change rims", new DateTime(2024, 5, 5, 17, 23, 51, 669, DateTimeKind.Utc).AddTicks(2068), new DateTime(2024, 5, 5, 17, 23, 51, 669, DateTimeKind.Utc).AddTicks(2069), 4, 700m, 2 });

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "TotalCost", "VehicleId" },
                values: new object[] { 1, 2, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change window", new DateTime(2024, 5, 5, 17, 23, 51, 669, DateTimeKind.Utc).AddTicks(2066), new DateTime(2024, 5, 5, 17, 23, 51, 669, DateTimeKind.Utc).AddTicks(2066), 5, 400m, 1 });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 5, 19, 23, 51, 669, DateTimeKind.Local).AddTicks(1993));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 5, 19, 23, 51, 669, DateTimeKind.Local).AddTicks(2014));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 48, 28, 638, DateTimeKind.Local).AddTicks(1128));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1135));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 48, 28, 638, DateTimeKind.Local).AddTicks(1136));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 48, 28, 638, DateTimeKind.Local).AddTicks(1138));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "AppointmentId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "TotalCost", "VehicleId" },
                values: new object[] { 2, "Change window", new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1108), new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1109), 5, null, 1 });

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "TotalCost", "VehicleId" },
                values: new object[] { 4, 4, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change rims", new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1112), new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1112), 4, null, 2 });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 48, 28, 638, DateTimeKind.Local).AddTicks(695));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 5, 5, 17, 48, 28, 638, DateTimeKind.Local).AddTicks(719));
        }
    }
}
