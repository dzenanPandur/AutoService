using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class add_seed : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 7, 6, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3964));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 7, 5, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3968));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 7, 7, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3970));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 7, 8, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3971));

            migrationBuilder.InsertData(
                table: "Appointments",
                columns: new[] { "Id", "ClientId", "Date", "IsOccupied", "RequestId" },
                values: new object[,]
                {
                    { 5, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 4, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3973), false, 5 },
                    { 6, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 3, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3975), false, 6 },
                    { 7, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2024, 2, 29, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3977), false, 7 },
                    { 8, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), new DateTime(2023, 12, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3979), false, 8 }
                });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3938), new DateTime(2024, 7, 6, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3939) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3941), new DateTime(2024, 7, 5, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3942) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3943), new DateTime(2024, 7, 7, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3944) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3945), new DateTime(2024, 7, 8, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3945) });

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 6, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3850));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 6, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3873));

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Message", "Status", "TotalCost", "VehicleId" },
                values: new object[,]
                {
                    { 5, 5, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change window", new DateTime(2024, 5, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3947), new DateTime(2024, 4, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3948), " ", 6, 1000m, 1 },
                    { 6, 6, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change engine cover", new DateTime(2024, 4, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3950), new DateTime(2024, 3, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3950), " ", 6, 200m, 2 },
                    { 7, 7, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Change mirrors", new DateTime(2024, 3, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3951), new DateTime(2024, 2, 29, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3952), " ", 6, 600m, 2 },
                    { 8, 8, new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"), "Check alignment", new DateTime(2024, 1, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3953), new DateTime(2023, 12, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3954), " ", 6, 1200m, 1 }
                });

            migrationBuilder.InsertData(
                table: "ServiceRequest",
                columns: new[] { "Id", "RequestId", "ServiceId" },
                values: new object[,]
                {
                    { 9, 5, 2 },
                    { 10, 5, 3 },
                    { 11, 6, 1 },
                    { 12, 6, 4 },
                    { 13, 7, 7 },
                    { 14, 7, 8 },
                    { 15, 8, 8 },
                    { 16, 8, 5 }
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 8);

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
    }
}
