class AppointmentModel {
  final int id;
  final bool isOccupied;
  final DateTime date;

  AppointmentModel({
    required this.id,
    required this.isOccupied,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isOccupied': isOccupied,
      'date': date.toIso8601String(),
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      isOccupied: json['isOccupied'],
      date: DateTime.parse(json['date']),
    );
  }
}
