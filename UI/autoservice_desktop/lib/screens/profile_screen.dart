// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/UserProvider.dart';
import '../models/userModel.dart';
import '../models/storageService.dart';
import '../models/updateUserModel.dart';

final UserProvider userProvider = UserProvider();

class ProfileScreen extends StatefulWidget {
  final StorageService? storageService;
  const ProfileScreen({Key? key, required this.storageService})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? phoneHelperText = 'Example: +38761234567 or 061234567';
  late bool emailExists;
  Future<bool> _checkEmailExists(String email, String userId) async {
    try {
      return await UserProvider().checkEmailExists(email, userId);
    } catch (error) {
      showSnackBar(context, "Error: $error", secondaryColor);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text(
          'Profile Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: UserProvider().getByUsername(widget.storageService!.username),
        builder: (context, AsyncSnapshot<userModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          } else {
            userModel user = snapshot.data!;
            TextEditingController firstNameController =
                TextEditingController(text: user.firstName);
            TextEditingController lastNameController =
                TextEditingController(text: user.lastName);
            TextEditingController genderController = TextEditingController(
                text: user.gender == 1 ? 'Male' : 'Female');
            TextEditingController cityController =
                TextEditingController(text: user.city);
            TextEditingController postalCodeController =
                TextEditingController(text: user.postalCode.toString());
            TextEditingController addressController =
                TextEditingController(text: user.address);
            TextEditingController birthDateController = TextEditingController(
                text: DateFormat('dd-MM-yyyy').format(user.birthDate));
            TextEditingController usernameController =
                TextEditingController(text: user.username);
            TextEditingController emailController =
                TextEditingController(text: user.email);
            TextEditingController phoneController =
                TextEditingController(text: user.phoneNumber);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildTextFormField(
                                  'First Name',
                                  firstNameController,
                                  false,
                                  15,
                                  _validateName),
                              _buildTextFormField('Last Name',
                                  lastNameController, false, 15, _validateName),
                              _buildTextFormField('Gender', genderController,
                                  true, null, _validateGender),
                              _buildTextFormField('City', cityController, false,
                                  15, _validateCity),
                              _buildTextFormField(
                                  'Postal Code',
                                  postalCodeController,
                                  false,
                                  10,
                                  _validatePostalCode),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextFormField('Address', addressController,
                                  false, 50, _validateAddress),
                              _buildTextFormField(
                                  'Birth Date',
                                  birthDateController,
                                  true,
                                  10,
                                  _validateBirthDate),
                              _buildTextFormField(
                                  'Username',
                                  usernameController,
                                  true,
                                  null,
                                  _validateUsername),
                              _buildTextFormField('Email', emailController,
                                  false, 50, _validateEmail),
                              _buildTextFormField('Phone', phoneController,
                                  false, 20, _validatePhone,
                                  helperText: phoneHelperText),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (emailController.text != "") {
                            emailExists = await _checkEmailExists(
                                emailController.text, user.userId);
                          }
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          try {
                            updateUserModel update = updateUserModel(
                              id: user.userId,
                              email: emailController.text,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              phoneNumber: phoneController.text,
                              address: addressController.text,
                              city: cityController.text,
                              userName: usernameController.text,
                              active: user.active,
                              gender: user.gender,
                              postalCode:
                                  int.tryParse(postalCodeController.text),
                            );
                            await userProvider.updateUser(update);

                            showSnackBar(context, 'Changes saved successfully.',
                                accentColor);
                          } catch (e) {
                            showSnackBar(context, 'Failed to save changes. $e',
                                secondaryColor);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 30),
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(fontSize: 18.0)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller,
      bool readOnly, int? characters, String? Function(String?) validator,
      {String? helperText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        maxLength: characters,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          helperText: helperText,
        ),
        validator: validator,
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    } else if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender cannot be empty';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City cannot be empty';
    } else if (!RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]+$').hasMatch(value)) {
      return 'City can only contain letters';
    }
    return null;
  }

  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal Code cannot be empty';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid Postal Code';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birth Date cannot be empty';
    }
    try {
      DateFormat('dd-MM-yyyy').parse(value);
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid email format';
    }
    if (emailExists) return 'Email is already taken';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone cannot be empty';
    }

    String pattern = r'^(?:\+387|0)(6[1-9]|3[1-9])[0-9]{6,7}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid phone number format \nExample: +38761234567 or 061234567';
    }

    return null;
  }
}
