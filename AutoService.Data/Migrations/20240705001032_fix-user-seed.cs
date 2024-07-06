using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class fixuserseed : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 7, 11, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4853));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 7, 10, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4858));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Date",
                value: new DateTime(2024, 7, 12, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4860));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Date",
                value: new DateTime(2024, 7, 13, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4862));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 5,
                column: "Date",
                value: new DateTime(2024, 5, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4863));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 6,
                column: "Date",
                value: new DateTime(2024, 4, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4865));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 7,
                column: "Date",
                value: new DateTime(2024, 3, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4867));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 8,
                column: "Date",
                value: new DateTime(2024, 1, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4869));

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 7, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4821), new DateTime(2024, 7, 11, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4822) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 7, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4825), new DateTime(2024, 7, 10, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4825) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 7, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4827), new DateTime(2024, 7, 12, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4827) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 7, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4828), new DateTime(2024, 7, 13, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4828) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 6, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4831), new DateTime(2024, 5, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4832) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4835), new DateTime(2024, 4, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4835) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 4, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4839), new DateTime(2024, 3, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4840) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 2, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4842), new DateTime(2024, 1, 5, 0, 10, 32, 32, DateTimeKind.Utc).AddTicks(4842) });

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"),
                column: "PhoneNumber",
                value: "061234567");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("b8396f1d-a29a-4856-a4c1-1312dc97a4a1"),
                column: "PhoneNumber",
                value: "061234567");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("f760ee5c-435b-4875-91a5-21a6a554513b"),
                column: "PhoneNumber",
                value: "061234567");

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1,
                column: "Date",
                value: new DateTime(2024, 7, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4700));

            migrationBuilder.UpdateData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2,
                column: "Date",
                value: new DateTime(2024, 7, 5, 2, 10, 32, 32, DateTimeKind.Local).AddTicks(4727));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
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

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 5,
                column: "Date",
                value: new DateTime(2024, 4, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3973));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 6,
                column: "Date",
                value: new DateTime(2024, 3, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3975));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 7,
                column: "Date",
                value: new DateTime(2024, 2, 29, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3977));

            migrationBuilder.UpdateData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 8,
                column: "Date",
                value: new DateTime(2023, 12, 30, 18, 42, 54, 907, DateTimeKind.Local).AddTicks(3979));

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
                table: "Request",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 5, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3947), new DateTime(2024, 4, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3948) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 4, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3950), new DateTime(2024, 3, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3950) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 3, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3951), new DateTime(2024, 2, 29, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3952) });

            migrationBuilder.UpdateData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "DateCompleted", "DateRequested" },
                values: new object[] { new DateTime(2024, 1, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3953), new DateTime(2023, 12, 30, 16, 42, 54, 907, DateTimeKind.Utc).AddTicks(3954) });

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("813a46d4-a59a-47ed-a88f-3143456e6f13"),
                column: "PhoneNumber",
                value: "123456789");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("b8396f1d-a29a-4856-a4c1-1312dc97a4a1"),
                column: "PhoneNumber",
                value: "123456789");

            migrationBuilder.UpdateData(
                schema: "dbo",
                table: "User",
                keyColumn: "Id",
                keyValue: new Guid("f760ee5c-435b-4875-91a5-21a6a554513b"),
                column: "PhoneNumber",
                value: "123456789");

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
        }
    }
}
