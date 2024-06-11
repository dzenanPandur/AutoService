using AutoService.Data.Entities.ServiceData;

namespace AutoService.Data.Database
{
    public class DefaultServiceData
    {
        public static IEnumerable<Appointment> Appointments
        {
            get => new List<Appointment>() {
                new Appointment
                {
                    Id = 1,
                    Date = DateTime.Now.AddDays(6),
                    IsOccupied = true,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    RequestId = 1
                },

                new Appointment
                {
                    Id = 2,
                    Date = DateTime.Now.AddDays(5),
                    IsOccupied = false,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    RequestId = 2
                },
                new Appointment
                {
                    Id = 3,
                    Date = DateTime.Now.AddDays(7),
                    IsOccupied = true,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    RequestId = 3
                },
                new Appointment
                {
                    Id = 4,
                    Date = DateTime.Now.AddDays(8),
                    IsOccupied = false,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    RequestId = 4
                },
            };
        }



        public static IEnumerable<Category> Categories
        {
            get => new List<Category>() {
                new Category
                {
                    Id = 1,
                    Name = "Checks",
                    isActive = true,
                },

                new Category
                {
                    Id = 2,
                    Name = "Changes",
                    isActive = true,
                },
                new Category
                {
                    Id = 3,
                    Name = "Tuning",
                    isActive = true,
                }
            };
        }

        public static IEnumerable<Service> Services
        {
            get => new List<Service>() {
                new Service
                {
                    Id = 1,
                    IsActive = true,
                    Name = "Change oil",
                    Price = 80,
                    CategoryId = 2
                },

                new Service
                {
                    Id = 2,
                    IsActive= true,
                    Name = "Change brakes",
                    Price = 250,
                    CategoryId = 2
                },
                new Service
                {
                    Id = 3,
                    IsActive= true,
                    Name = "Change freon",
                    Price = 80,
                    CategoryId = 2
                },
                new Service
                {
                    Id = 4,
                    IsActive= true,
                    Name = "Change lights",
                    Price = 35,
                    CategoryId = 2
                },
                new Service
                {
                    Id = 5,
                    IsActive = true,
                    Name = "Check oil",
                    Price = 5,
                    CategoryId= 1
                },
                new Service
                {
                    Id = 6,
                    IsActive = true,
                    Name = "Check brakes",
                    Price = 60,
                    CategoryId= 1
                },
                new Service
                {
                    Id = 7,
                    IsActive = true,
                    Name = "Check lights",
                    Price = 5,
                    CategoryId= 1
                },
                new Service
                {
                    Id = 8,
                    IsActive = true,
                    Name = "Check freon",
                    Price = 10,
                    CategoryId= 1
                },

                new Service
                {
                    Id = 9,
                    IsActive = true,
                    Name = "ECU Tune",
                    Price = 300,
                    CategoryId= 3
                },
            };
        }
        public static IEnumerable<Request> Requests
        {
            get => new List<Request>() {
                new Request
                {
                    Id = 1,
                    AppointmentId = 1,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    CustomRequest="Change tires",
                    DateCompleted=DateTime.UtcNow,
                    DateRequested=DateTime.UtcNow,
                    Status= (Enums.Status)2,
                    VehicleId=1,
                    TotalCost=600,
                    Message = " ",

                },

                new Request
                {
                    Id = 2,
                    AppointmentId = 2,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    CustomRequest="Change window",
                    DateCompleted=DateTime.UtcNow,
                    DateRequested=DateTime.UtcNow,
                    Status= (Enums.Status)6,
                    VehicleId=1,
                    TotalCost=450,
                    Message = " ",

                },
                new Request
                {
                    Id = 3,
                    AppointmentId = 3,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    CustomRequest="Change bumper",
                    DateCompleted=DateTime.UtcNow,
                    DateRequested=DateTime.UtcNow,
                    Status= (Enums.Status)7,
                    VehicleId=1,
                    TotalCost = 400,
                    Message = " ",


                },
                new Request
                {
                    Id = 4,
                    AppointmentId = 4,
                    ClientId =Guid.Parse("813A46D4-A59A-47ED-A88F-3143456E6F13"),
                    CustomRequest="Change rims",
                    DateCompleted=DateTime.UtcNow,
                    DateRequested=DateTime.UtcNow,
                    Status= (Enums.Status)4,
                    VehicleId=2,
                    TotalCost = 700,
                    Message = " ",
                },
            };
        }

        public static IEnumerable<ServiceRequest> ServiceRequests
        {
            get => new List<ServiceRequest>() {

                new ServiceRequest
                {
                    Id = 8,
                    RequestId = 1,
                    ServiceId = 1
                },
                new ServiceRequest
                {
                    Id = 7,
                    RequestId = 1,
                    ServiceId = 2
                },
                new ServiceRequest
                {
                    Id = 6,
                    RequestId = 2,
                    ServiceId = 3
                },
                new ServiceRequest
                {Id = 5,
                    RequestId = 2,
                    ServiceId = 4
                },
                new ServiceRequest
                {Id = 4,
                    RequestId = 3,
                    ServiceId = 1
                },
                new ServiceRequest
                {Id = 3,
                    RequestId = 3,
                    ServiceId = 2
                },
                new ServiceRequest
                {Id = 2,
                    RequestId = 3,
                    ServiceId = 3
                },
                new ServiceRequest
                {Id = 1,
                    RequestId = 4,
                    ServiceId = 1
                },
            };
        }
    }
}
