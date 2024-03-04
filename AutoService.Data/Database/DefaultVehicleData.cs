using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.Database
{
    public class DefaultVehicleData
    {
        public static IEnumerable<VehicleFuelType> VehicleFuelTypes
        {
            get => new List<VehicleFuelType>() {
                new VehicleFuelType
                {
                    Id = 1,
                    Name = "Petrol"
                },

                new VehicleFuelType
                {
                    Id = 2,
                    Name = "Diesel"
                },
                new VehicleFuelType
                {
                    Id = 3,
                    Name = "Electric"
                },
                new VehicleFuelType
                {
                    Id = 4,
                    Name = "Hybrid"
                },
            };
        }
        public static IEnumerable<VehicleType> VehicleTypes
        {
            get => new List<VehicleType>() {
                new VehicleType
                {
                    Id = 1,
                    Name = "Sedan"
                },

                new VehicleType
                {
                    Id = 2,
                    Name = "Hatchback"
                },
                new VehicleType
                {
                    Id = 3,
                    Name = "SUV"
                },
                new VehicleType
                {
                    Id = 4,
                    Name = "Coupe"
                },
                new VehicleType
                {
                    Id = 5,
                    Name = "Minivan"
                },
                new VehicleType
                {
                    Id = 6,
                    Name = "Convertible"
                },
                new VehicleType
                {
                    Id = 7,
                    Name = "Station wagon"
                },
                new VehicleType
                {
                    Id = 8,
                    Name = "Crossover"
                },
                new VehicleType
                {
                    Id = 9,
                    Name = "Other"
                },
            };
        }
        public static IEnumerable<TransmissionType> TransmissionTypes
        {
            get => new List<TransmissionType>() {
                new TransmissionType
                {
                    Id = 1,
                    Name = "Manual"
                },

                new TransmissionType
                {
                    Id = 2,
                    Name = "Automatic"
                }
            };
        }
        public static IEnumerable<Vehicle> Vehicles
        {
            get => new List<Vehicle>() {
                new Vehicle
                {
                    Id = 1,
                    Make= "Peugeot",
                    Model = "308",
                    Vin = "1231AKHJKHJ1213JH",
                    ClientId = Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    FuelTypeId = 2,
                    VehicleTypeId = 2,
                    TransmissionTypeId = 1,
                    Mileage = 195123,
                    Status = (Enums.Status)2,
                    ManufactureYear=2016



                },

                new Vehicle
                {
                    Id = 2,
                    Make= "Toyota",
                    Model = "Yaris",
                    Vin = "12151AKGHEQRH15121JH",
                    ClientId = Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    FuelTypeId = 1,
                    VehicleTypeId = 2,
                    TransmissionTypeId = 1,
                    Mileage = 18590,
                    Status = (Enums.Status)4,
                    ManufactureYear=2008
                }
            };
        }
        public static IEnumerable<VehicleServiceRecord> VehicleServiceRecords
        {
            get => new List<VehicleServiceRecord>() {
                new VehicleServiceRecord
                {
                    Id = 1,
                    Cost = 1500,
                    Date = DateTime.Now,
                    MileageAtTimeOfService=185100,
                    Notes="Found broken light",
                    VehicleId=1

                },

                new VehicleServiceRecord
                {
                    Id = 2,
                    Cost = 500,
                    Date = DateTime.Now,
                    MileageAtTimeOfService=17800,
                    Notes="",
                    VehicleId=2
                }
            };
        }

        public static IEnumerable<ServicesPerformed> ServicesPerformeds
        {
            get => new List<ServicesPerformed>() {
                new ServicesPerformed
                {
                    Id = 1,
                    ServiceId = 1,
                    RecordId = 1
                },
                new ServicesPerformed
                {
                    Id = 2,
                    ServiceId = 2,
                    RecordId = 1
                },
                new ServicesPerformed
                {
                    Id = 3,
                    ServiceId = 3,
                    RecordId = 1
                },
                new ServicesPerformed
                {
                    Id = 4,
                    ServiceId = 4,
                    RecordId = 1
                },
                new ServicesPerformed
                {
                    Id = 5,
                    ServiceId = 3,
                    RecordId = 2
                },
                new ServicesPerformed
                {
                    Id = 6,
                    ServiceId = 1,
                    RecordId = 2
                },
            };
        }
    }
}
