class userModel {
  final String userId;
  final String firstName;
  final String lastName;
  final bool active;
  final int gender;
  final String city;
  final String address;
  final int postalCode;
  final DateTime birthDate;
  final String email;
  final String phoneNumber;
  final String username;
  final String role;

  userModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.active,
    required this.gender,
    required this.city,
    required this.address,
    required this.postalCode,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.role,
  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      userId: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      active: json['active'],
      gender: json['gender'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postalCode'],
      birthDate: DateTime.parse(json['birthDate']),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      username: json['userName'],
      role: json['roleName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'active': active,
      'gender': gender,
      'city': city,
      'address': address,
      'postalCode': postalCode,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': username,
      'roleName': role,
    };
  }
}
