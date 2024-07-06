class updateUserModel {
  String id;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? city;
  int? postalCode;
  bool? active;
  int? gender;

  updateUserModel(
      {required this.id,
      this.userName,
      this.email,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.address,
      this.city,
      this.postalCode,
      this.active,
      this.gender});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'active': active,
      'gender': gender,
    };
  }

  factory updateUserModel.fromJson(Map<String, dynamic> json) {
    return updateUserModel(
        id: json['id'],
        userName: json['userName'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        city: json['city'],
        postalCode: json['postalCode'],
        active: json['active'],
        gender: json['gender']);
  }
}
