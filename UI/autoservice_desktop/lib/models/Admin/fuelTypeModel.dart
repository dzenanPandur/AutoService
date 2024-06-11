class FuelTypeModel {
  final int id;
  String name;
  bool isActive;

  FuelTypeModel({required this.id, required this.name, required this.isActive});

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        isActive: json['isActive']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
    };
  }
}
