class UpdateRequestModel {
  int status;
  int id;
  double? totalCost;
  int vehicleId;
  String? message;

  UpdateRequestModel(
      {required this.status,
      required this.id,
      required this.totalCost,
      required this.vehicleId,
      this.message});

  factory UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateRequestModel(
        status: json['status'] ?? 1,
        id: json['id'] ?? 0,
        totalCost: json['totalCost'] ?? 0.0,
        vehicleId: json['vehicleId'] ?? 0,
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'totalCost': totalCost,
      'vehicleId': vehicleId,
      'message': message
    };
  }
}
