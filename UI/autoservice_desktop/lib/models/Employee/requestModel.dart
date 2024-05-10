class RequestModel {
  String status;
  String vehicleName;
  String clientName;
  int id;
  int statusId;
  DateTime dateRequested;
  DateTime dateCompleted;
  String? customRequest;
  List<int> serviceIdList;
  int vehicleId;
  double? totalCost;

  RequestModel({
    required this.status,
    required this.vehicleName,
    required this.clientName,
    required this.id,
    required this.dateRequested,
    required this.dateCompleted,
    required this.statusId,
    this.customRequest,
    required this.serviceIdList,
    required this.vehicleId,
    this.totalCost,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      status: json['status'] ?? '',
      statusId: json['statusId'] ?? '',
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
      totalCost: json['totalCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusId': statusId,
      'vehicleName': vehicleName,
      'clientName': clientName,
      'id': id,
      'dateRequested': dateRequested.toIso8601String(),
      'dateCompleted': dateCompleted.toIso8601String(),
      'customRequest': customRequest,
      'serviceIdList': serviceIdList,
      'vehicleId': vehicleId,
      'totalCost': totalCost,
    };
  }
}
