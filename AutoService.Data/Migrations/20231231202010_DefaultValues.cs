using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AutoService.Data.Migrations
{
    public partial class DefaultValues : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Appointments",
                columns: new[] { "Id", "ClientId", "Date", "IsOccupied", "RequestId" },
                values: new object[,]
                {
                    { 1, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), new DateTime(2023, 12, 31, 21, 20, 9, 627, DateTimeKind.Local).AddTicks(8028), true, 1 },
                    { 2, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8034), false, 2 },
                    { 3, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), new DateTime(2023, 12, 31, 21, 20, 9, 627, DateTimeKind.Local).AddTicks(8036), true, 3 },
                    { 4, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), new DateTime(2023, 12, 31, 21, 20, 9, 627, DateTimeKind.Local).AddTicks(8038), false, 4 }
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
                    { 3, 1, true, "Check lights", 5m },
                    { 4, 3, true, "ECU Tune", 300m }
                });

            migrationBuilder.InsertData(
                table: "Vehicles",
                columns: new[] { "Id", "ClientId", "FuelTypeId", "Make", "ManufactureYear", "Mileage", "Model", "Status", "TransmissionTypeId", "VehicleTypeId", "Vin" },
                values: new object[,]
                {
                    { 1, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), 2, "Peugeot", 2016, 195123, "308", 2, 1, 2, "1231AKHJKHJ1213JH" },
                    { 2, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), 1, "Toyota", 2008, 18590, "Yaris", 4, 1, 2, "12151AKGHEQRH15121JH" }
                });

            migrationBuilder.InsertData(
                table: "Request",
                columns: new[] { "Id", "AppointmentId", "ClientId", "CustomRequest", "DateCompleted", "DateRequested", "Status", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), "Change tires", new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8007), new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8008), 2, 1 },
                    { 2, 2, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), "Change window", new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8011), new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8011), 5, 1 },
                    { 3, 3, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), "Change bumper", new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8013), new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8013), 3, 1 },
                    { 4, 4, new Guid("45edb75b-2876-4709-aab9-3382d5e8184b"), "Change rims", new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8015), new DateTime(2023, 12, 31, 20, 20, 9, 627, DateTimeKind.Utc).AddTicks(8015), 4, 1 }
                });

            migrationBuilder.InsertData(
                table: "VehicleServiceRecords",
                columns: new[] { "Id", "Cost", "Date", "MileageAtTimeOfService", "Notes", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1500m, new DateTime(2023, 12, 31, 21, 20, 9, 627, DateTimeKind.Local).AddTicks(7864), 185100, "Found broken light", 1 },
                    { 2, 500m, new DateTime(2023, 12, 31, 21, 20, 9, 627, DateTimeKind.Local).AddTicks(7929), 17800, "", 2 }
                });

            migrationBuilder.InsertData(
                table: "ServiceRequest",
                columns: new[] { "Id", "RequestId", "ServiceId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 1, 2 },
                    { 3, 2, 3 },
                    { 4, 2, 4 },
                    { 5, 3, 1 },
                    { 6, 3, 2 },
                    { 7, 3, 3 },
                    { 8, 4, 1 }
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
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "ServiceRequest",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "ServicesPerformed",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Request",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VehicleServiceRecords",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Appointments",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Categories",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Vehicles",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Vehicles",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "TransmissionTypes",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VehicleFuelTypes",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VehicleTypes",
                keyColumn: "Id",
                keyValue: 2);
        }
    }
}
