class TransmissionTypeModel {
  final int id;
  final String name;

  TransmissionTypeModel({
    required this.id,
    required this.name,
  });

  factory TransmissionTypeModel.fromJson(Map<String, dynamic> json) {
    return TransmissionTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
