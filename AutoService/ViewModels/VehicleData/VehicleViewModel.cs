using AutoService.Data.DTO.UserData;
using AutoService.Data.DTO.VehicleData;
using AutoService.Data.Enums;
using Microsoft.Data.SqlClient;

namespace AutoService.ViewModels.VehicleData
{
    public class VehicleViewModel : VehicleDto
    {
        public VehicleViewModel()
        {

        }

        public VehicleViewModel(VehicleDto dto)
        {
            Id = dto.Id;
            Make = dto.Make;
            Model = dto.Model;
            Vin = dto.Vin;
            ManufactureYear = dto.ManufactureYear;
            Mileage = dto.Mileage;
            Status = dto.Status.ToString();
            VehicleTypeName = dto.VehicleType.Name;
            TransmissionTypeName = dto.TransmissionType.Name;
            VehicleFuelTypeName = dto.FuelType.Name;
        }

        public string Status { get; set; }
        public string VehicleTypeName { get; set; }
        public string TransmissionTypeName { get; set; }
        public string VehicleFuelTypeName { get; set; }
    }
}