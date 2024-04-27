class VehicleServiceRecordModel {
  final int id;
  final DateTime date;
  final int mileageAtTimeOfService;
  final double cost;
  final String notes;
  final int vehicleId;
  final List<int> serviceIdList;

  VehicleServiceRecordModel({
    required this.id,
    required this.date,
    required this.mileageAtTimeOfService,
    required this.cost,
    required this.notes,
    required this.vehicleId,
    required this.serviceIdList,
  });

  factory VehicleServiceRecordModel.fromJson(Map<String, dynamic> json) {
    return VehicleServiceRecordModel(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      mileageAtTimeOfService: json['mileageAtTimeOfService'] as int,
      cost: json['cost'] as double,
      notes: json['notes'] as String,
      vehicleId: json['vehicleId'] as int,
      serviceIdList: List<int>.from(json['serviceIdList'] as List),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mileageAtTimeOfService': mileageAtTimeOfService,
      'cost': cost,
      'notes': notes,
      'vehicleId': vehicleId,
      'serviceIdList': serviceIdList,
    };
  }
}
