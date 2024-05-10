using AutoService.Data.DTO.VehicleData;

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
            StatusId = (int)dto.Status;
            VehicleTypeName = dto.VehicleType.Name;
            TransmissionTypeName = dto.TransmissionType.Name;
            VehicleFuelTypeName = dto.FuelType.Name;
            VehicleTypeId = dto.VehicleTypeId;
            TransmissionTypeId = dto.TransmissionTypeId;
            FuelTypeId = dto.FuelTypeId;
            isArchived = dto.isArchived;
        }
        public int StatusId { get; set; }
        public string Status { get; set; }
        public string VehicleTypeName { get; set; }
        public string TransmissionTypeName { get; set; }
        public string VehicleFuelTypeName { get; set; }
        public string ClientName { get; set; }
    }
}