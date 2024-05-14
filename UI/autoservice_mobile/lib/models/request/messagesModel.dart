class MessageModel {
  final int id;
  final String message;

  MessageModel({
    required this.id,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
    };
  }
}
