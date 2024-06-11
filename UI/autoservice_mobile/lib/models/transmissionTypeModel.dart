class TransmissionTypeModel {
  final int id;
  final String name;
  bool isActive;

  TransmissionTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory TransmissionTypeModel.fromJson(Map<String, dynamic> json) {
    return TransmissionTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
