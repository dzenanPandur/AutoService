class FuelTypeModel {
  final int id;
  final String name;
  bool isActive;

  FuelTypeModel({required this.id, required this.name, required this.isActive});

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
