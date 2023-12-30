using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using AutoService.Data.Entities.UserData;
using AutoService.Data.Entities.ServiceData;
using AutoService.Data.Entities.VehicleData;
using AutoService.Data.Entities.ClientData;

namespace AutoService.Data.Database
{
    public partial class AutoServiceContext : IdentityDbContext<User, Role, Guid>

    {
        public AutoServiceContext()
        {
        }

        public AutoServiceContext(DbContextOptions<AutoServiceContext> options)
        : base(options)
        {
        }

        //public virtual DbSet<ApplicationUserProfilePhoto> ApplicationUserProfilePhotos { get; set; }
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<Client> Clients { get; set; }
        public virtual DbSet<ProfilePhoto> ProfilePhotos { get; set; }
        public virtual DbSet<Service> Services { get; set; }
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<Request> Request { get; set; }
        public virtual DbSet<ServiceRequest> ServiceRequest { get; set; }
        public virtual DbSet<ServicesPerformed> ServicesPerformed { get; set; }
        public virtual DbSet<TransmissionType> TransmissionTypes { get; set; }
        public virtual DbSet<Vehicle> Vehicles { get; set; }
        public virtual DbSet<VehicleFuelType> VehicleFuelTypes { get; set; }
        public virtual DbSet<VehicleServiceRecord> VehicleServiceRecords { get; set; }
        public virtual DbSet<VehicleType> VehicleTypes { get; set; }



        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<User>().ToTable("User", "dbo");
            builder.Entity<Role>().ToTable("Role", "dbo");
            builder.Entity<IdentityUserRole<Guid>>().ToTable("UserRole", "dbo");
            builder.Entity<IdentityUserClaim<Guid>>().ToTable("UserClaim", "dbo");
            builder.Entity<IdentityUserLogin<Guid>>().ToTable("UserLogin", "dbo");
            builder.Entity<IdentityRoleClaim<Guid>>().ToTable("RoleClaim", "dbo");
            builder.Entity<IdentityUserToken<Guid>>().ToTable("UserToken", "dbo");
            builder.Entity<Role>().HasData(DefaultRoleData.Roles);

            //VehicleServiceRecord N : 1 Vehicle

            builder.Entity<Vehicle>(vehicle =>
            {
                vehicle
                    .HasMany(v => v.Records)
                    .WithOne(r => r.Vehicle)
                    .HasForeignKey(r => r.VehicleId)
                    .OnDelete(DeleteBehavior.NoAction);
            });

            //Request N : 1 Vehicle

            builder.Entity<Vehicle>(vehicle =>
            {
                vehicle
                    .HasMany(r => r.Requests)
                    .WithOne(v => v.Vehicle)
                    .HasForeignKey(r => r.VehicleId)
                    .OnDelete(DeleteBehavior.NoAction);

                vehicle
                    .HasOne(v => v.TransmissionType)
                    .WithMany()
                    .HasForeignKey(v => v.TransmissionTypeId)
                    .OnDelete(DeleteBehavior.NoAction);

                vehicle
                    .HasOne(v => v.FuelType)
                    .WithMany()
                    .HasForeignKey(v => v.FuelTypeId)
                    .OnDelete(DeleteBehavior.NoAction);

                vehicle
                    .HasOne(v => v.VehicleType)
                    .WithMany()
                    .HasForeignKey(v => v.VehicleTypeId)
                    .OnDelete(DeleteBehavior.NoAction);
            });

            //Request N : 1 Appointment

            builder.Entity<Appointment>(appointment =>
            {
                appointment
                    .HasOne(r => r.Request)
                    .WithOne(a => a.Appointment)
                    .HasForeignKey<Request>(a => a.AppointmentId)
                    .OnDelete(DeleteBehavior.NoAction);
            });

            //ApplicationUserProfilePhoto N : 1 ProfilePhoto

            //builder.Entity<ProfilePhoto>(profilePhoto =>
            //{
            //    profilePhoto
            //        .HasMany(a => a.ApplicationUserProfilePhotos)
            //        .WithOne(p => p.ProfilePhoto)
            //        .HasForeignKey(a => a.ProfilePhotoId)
            //        .OnDelete(DeleteBehavior.NoAction);
            //});

            //Client N : 1 Appointment

            builder.Entity<Client>(client =>
            {
                client
                    .HasMany(a => a.Appointments)
                    .WithOne(c => c.Client)
                    .HasForeignKey(a => a.ClientId)
                    .OnDelete(DeleteBehavior.NoAction);

                client
                    .HasMany(r => r.Requests)
                    .WithOne(c => c.Client)
                    .HasForeignKey(r => r.ClientId)
                    .OnDelete(DeleteBehavior.NoAction);

                client
                    .HasMany(v => v.Vehicles)
                    .WithOne(c => c.Client)
                    .HasForeignKey(r => r.ClientId)
                    .OnDelete(DeleteBehavior.NoAction);
            });

            builder.Entity<Service>(service =>
            {
                service
                    .HasOne(s => s.Category)
                    .WithMany()
                    .HasForeignKey(s => s.CategoryId)
                    .OnDelete(DeleteBehavior.NoAction);

                service
                    .HasMany(s => s.Requests)
                    .WithMany(r => r.Services)
                    .UsingEntity<ServiceRequest>(
                        s => s
                            .HasOne(sr => sr.Request)
                            .WithMany(r => r.ServiceRequests)
                            .HasForeignKey(sr => sr.RequestId)
                            .OnDelete(DeleteBehavior.Cascade),
                        r => r
                            .HasOne(sr => sr.Service)
                            .WithMany(s => s.ServiceRequests)
                            .HasForeignKey(sr => sr.ServiceId)
                            .OnDelete(DeleteBehavior.Cascade)
                );
            });

            builder.Entity<VehicleServiceRecord>(record =>
            {
                record
                    .HasMany(r => r.Services)
                    .WithMany(s => s.Records)
                    .UsingEntity<ServicesPerformed>(
                        r => r
                            .HasOne(sr => sr.Service)
                            .WithMany(s => s.ServicesPerformeds)
                            .HasForeignKey(sr => sr.ServiceId)
                            .OnDelete(DeleteBehavior.Cascade),
                        s => s
                            .HasOne(sr => sr.Record)
                            .WithMany(r => r.ServicesPerformeds)
                            .HasForeignKey(sr => sr.RecordId)
                            .OnDelete(DeleteBehavior.Cascade)
                       
                );
            });

            builder.Entity<Role>(role =>
            {
                role
                    .HasMany(r => r.Users)
                    .WithOne(u => u.Role)
                    .HasForeignKey(u => u.RoleId)
                    .OnDelete(DeleteBehavior.NoAction);
            });

        }
    }
}