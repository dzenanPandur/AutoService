class TransmissionTypeModel {
  final int id;
  String name;
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
