using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class archivevehicle_requestcost : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.AddColumn<bool>(
                name: "isArchived",
                table: "Vehicles",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<decimal>(
                name: "TotalCost",
                table: "Request",
                type: "decimal(18,2)",
                nullable: true);

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
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1108), new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1109) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested", "VehicleId" },
                values: new object[] { new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1112), new DateTime(2024, 5, 5, 15, 48, 28, 638, DateTimeKind.Utc).AddTicks(1112), 2 });

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

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isArchived",
                table: "Vehicles");

            migrationBuilder.DropColumn(
                name: "TotalCost",
                table: "Request");

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 2, 28, 20, 13, 21, 507, DateTimeKind.Local).AddTicks(6942));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6945));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 2, 28, 20, 13, 21, 507, DateTimeKind.Local).AddTicks(6946));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 2, 28, 20, 13, 21, 507, DateTimeKind.Local).AddTicks(6948));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6930), new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6930) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested", "VehicleId" },
                values: new object[] { new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6933), new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6933), 1 });

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change tires", new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6927), new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6928), 2, 1 },
                    { 3, 3, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change bumper", new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6931), new DateTime(2024, 2, 28, 19, 13, 21, 507, DateTimeKind.Utc).AddTicks(6932), 3, 1 }
                });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 2, 28, 20, 13, 21, 507, DateTimeKind.Local).AddTicks(6851));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 2, 28, 20, 13, 21, 507, DateTimeKind.Local).AddTicks(6875));
        }
    }
}
