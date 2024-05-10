class StorageService {
  final String userId;
  final String firstName;
  final String lastName;
  static String? token;
  final String username;
  final String role;
  bool? isActive;

  StorageService({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.role,
    this.isActive,
  });

  factory StorageService.fromJson(Map<String, dynamic> json) {
    return StorageService(
        userId: json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        username: json['username'],
        role: json['role'],
        isActive: json['isActive']);
  }
}
