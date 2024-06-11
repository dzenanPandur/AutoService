class MessageModel {
  final int id;
  final String message;
  String vehicleName;

  MessageModel({
    required this.id,
    required this.message,
    required this.vehicleName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      vehicleName: json['vehicleName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'message': message, 'vehicleName': vehicleName};
  }
}
