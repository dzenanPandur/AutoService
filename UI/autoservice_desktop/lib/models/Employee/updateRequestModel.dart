class UpdateRequestModel {
  int status;
  int id;
  double? totalCost;

  UpdateRequestModel(
      {required this.status, required this.id, required this.totalCost});

  factory UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateRequestModel(
        status: json['status'] ?? 1,
        id: json['id'] ?? 0,
        totalCost: json['totalCost'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'totalCost': totalCost,
    };
  }
}
