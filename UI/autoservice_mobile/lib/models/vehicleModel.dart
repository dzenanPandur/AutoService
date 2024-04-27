class VehicleModel {
  int id;
  String make;
  String model;
  String vin;
  int? manufactureYear;
  int? mileage;
  //String? status;
  int? statusId;
  var status;
  String? vehicleFuelTypeName;
  String? transmissionTypeName;
  String? vehicleTypeName;
  int? fuelTypeId;
  int? transmissionTypeId;
  int? vehicleTypeId;

  VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.vin,
    required this.manufactureYear,
    required this.mileage,
    this.statusId,
    this.status,
    this.vehicleFuelTypeName,
    this.transmissionTypeName,
    this.vehicleTypeName,
    this.fuelTypeId,
    this.transmissionTypeId,
    this.vehicleTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'vin': vin,
      'manufactureYear': manufactureYear,
      'mileage': mileage,
      'statusId': statusId,
      'status': status,
      'vehicleFuelTypeName': vehicleFuelTypeName,
      'transmissionTypeName': transmissionTypeName,
      'vehicleTypeName': vehicleTypeName,
      'fuelTypeId': fuelTypeId,
      'transmissionTypeId': transmissionTypeId,
      'vehicleTypeId': vehicleTypeId,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      vin: json['vin'],
      manufactureYear: json['manufactureYear'],
      mileage: json['mileage'],
      statusId: json['statusId'],
      status: json['status'],
      vehicleFuelTypeName: json['vehicleFuelTypeName'],
      transmissionTypeName: json['transmissionTypeName'],
      vehicleTypeName: json['vehicleTypeName'],
      fuelTypeId: json['fuelTypeId'],
      transmissionTypeId: json['transmissionTypeId'],
      vehicleTypeId: json['vehicleTypeId'],
    );
  }
}
