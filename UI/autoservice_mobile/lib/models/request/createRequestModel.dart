import 'package:autoservice_mobile/models/appointmentModel.dart';

class CreateRequestModel {
  final int id;
  final int status;
  final DateTime dateRequested;
  final DateTime? dateCompleted;
  final double totalCost;
  final String customRequest;
  final String message;
  final AppointmentModel appointment;
  final String clientId;
  final int vehicleId;
  final List<int> serviceIdList;

  CreateRequestModel({
    required this.id,
    required this.status,
    required this.dateRequested,
    this.dateCompleted,
    required this.totalCost,
    required this.customRequest,
    required this.message,
    required this.appointment,
    required this.clientId,
    required this.vehicleId,
    required this.serviceIdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'dateRequested': dateRequested.toIso8601String(),
      'dateCompleted': dateCompleted?.toIso8601String(),
      'totalCost': totalCost,
      'customRequest': customRequest,
      'message': message,
      'appointment': appointment.toJson(),
      'clientId': clientId,
      'vehicleId': vehicleId,
      'serviceIdList': serviceIdList,
    };
  }

  factory CreateRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateRequestModel(
      id: json['id'],
      status: json['status'],
      dateRequested: DateTime.parse(json['dateRequested']),
      dateCompleted: DateTime.parse(json['dateCompleted']),
      totalCost: json['totalCost'],
      customRequest: json['customRequest'],
      message: json['message'],
      appointment: AppointmentModel.fromJson(json['appointment']),
      clientId: json['clientId'],
      vehicleId: json['vehicleId'],
      serviceIdList: List<int>.from(json['serviceIdList']),
    );
  }
}
