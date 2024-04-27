class RequestModel {
  String status;
  String vehicleName;
  String clientName;
  int id;
  DateTime dateRequested;
  DateTime dateCompleted;
  String? customRequest;
  List<int> serviceIdList;
  int? vehicleId;

  RequestModel({
    required this.status,
    required this.vehicleName,
    required this.clientName,
    required this.id,
    required this.dateRequested,
    required this.dateCompleted,
    this.customRequest,
    required this.serviceIdList,
    required this.vehicleId,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      status: json['status'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      clientName: json['clientName'] ?? '',
      id: json['id'] ?? 0,
      dateRequested:
          DateTime.parse(json['dateRequested'] ?? DateTime.now().toString()),
      dateCompleted:
          DateTime.parse(json['dateCompleted'] ?? DateTime.now().toString()),
      customRequest: json['customRequest'] ?? '',
      serviceIdList: List<int>.from(json['serviceIdList'] ?? []),
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'vehicleName': vehicleName,
      'clientName': clientName,
      'id': id,
      'dateRequested': dateRequested.toIso8601String(),
      'dateCompleted': dateCompleted.toIso8601String(),
      'customRequest': customRequest,
      'serviceIdList': serviceIdList,
      'vehicleId': vehicleId,
    };
  }
}
