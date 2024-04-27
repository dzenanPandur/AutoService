class FuelTypeModel {
  final int id;
  final String name;

  FuelTypeModel({
    required this.id,
    required this.name,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
