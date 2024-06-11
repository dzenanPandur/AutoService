class VehicleTypeModel {
  final int id;
  final String name;
  bool isActive;

  VehicleTypeModel(
      {required this.id, required this.name, required this.isActive});

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
