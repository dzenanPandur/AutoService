class createUserModel {
  final String firstName;
  final String lastName;
  final int gender;
  final bool active;
  final String city;
  final String address;
  final int postalCode;
  final DateTime birthDate;
  final String email;
  final String phoneNumber;
  final String userName;
  final String roleId;
  final String password;
  final String passwordConfirm;

  createUserModel({
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
    required this.userName,
    required this.roleId,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
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
      'userName': userName,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'roleId': roleId,
    };
  }

  factory createUserModel.fromJson(Map<String, dynamic> json) {
    return createUserModel(
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
      userName: json['userName'],
      roleId: json['roleId'],
      password: json['password'],
      passwordConfirm: json['passwordConfirm'],
    );
  }
}
