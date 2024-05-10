class RequestModel {
  final String status;
  final String vehicleName;
  final String clientName;
  final int vehicleId;
  final int id;
  final DateTime dateRequested;
  final DateTime dateCompleted;
  final String customRequest;
  final List<int> serviceIdList;
  final double totalCost;

  RequestModel({
    required this.status,
    required this.vehicleName,
    required this.clientName,
    required this.vehicleId,
    required this.id,
    required this.dateRequested,
    required this.dateCompleted,
    required this.customRequest,
    required this.serviceIdList,
    required this.totalCost,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      status: json['status'],
      vehicleName: json['vehicleName'],
      clientName: json['clientName'],
      vehicleId: json['vehicleId'],
      id: json['id'],
      dateRequested: DateTime.parse(json['dateRequested']),
      dateCompleted: DateTime.parse(json['dateCompleted']),
      customRequest: json['customRequest'],
      serviceIdList: List<int>.from(json['serviceIdList']),
      totalCost: json['totalCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'vehicleName': vehicleName,
      'clientName': clientName,
      'vehicleId': vehicleId,
      'id': id,
      'dateRequested': dateRequested.toIso8601String(),
      'dateCompleted': dateCompleted.toIso8601String(),
      'customRequest': customRequest,
      'serviceIdList': serviceIdList,
      'totalCost': totalCost,
    };
  }
}
