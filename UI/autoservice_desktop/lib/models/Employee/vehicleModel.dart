class VehicleModel {
  String status;
  int statusId;
  String vehicleTypeName;
  String transmissionTypeName;
  String vehicleFuelTypeName;
  int id;
  String make;
  String model;
  String vin;
  int manufactureYear;
  int mileage;
  String clientName;

  VehicleModel({
    required this.statusId,
    required this.status,
    required this.vehicleTypeName,
    required this.transmissionTypeName,
    required this.vehicleFuelTypeName,
    required this.id,
    required this.make,
    required this.model,
    required this.vin,
    required this.manufactureYear,
    required this.mileage,
    required this.clientName,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
        statusId: json['statusId'] ?? 0,
        status: json['status'] ?? 'No status',
        vehicleTypeName: json['vehicleTypeName'] ?? '',
        transmissionTypeName: json['transmissionTypeName'] ?? '',
        vehicleFuelTypeName: json['vehicleFuelTypeName'] ?? '',
        id: json['id'] ?? 0,
        make: json['make'] ?? '',
        model: json['model'] ?? '',
        vin: json['vin'] ?? '',
        manufactureYear: json['manufactureYear'] ?? 0,
        mileage: json['mileage'] ?? 0,
        clientName: json['clientName'] ?? '');
  }
}
