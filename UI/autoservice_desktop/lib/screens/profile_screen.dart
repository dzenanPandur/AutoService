// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/UserProvider.dart';
import '../models/userModel.dart';
import '../models/storageService.dart';
import '../models/updateUserModel.dart';

final UserProvider userProvider = UserProvider();

class ProfileScreen extends StatelessWidget {
  final StorageService? storageService;
  const ProfileScreen({Key? key, required this.storageService})
      : super(key: key);

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
        future: UserProvider().getByUsername(storageService!.username),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildTextField(
                                'First Name', firstNameController, false, 15),
                            _buildTextField(
                                'Last Name', lastNameController, false, 15),
                            _buildTextField(
                                'Gender', genderController, true, null),
                            _buildTextField('City', cityController, false, 15),
                            _buildTextField(
                                'Postal Code', postalCodeController, false, 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                                'Address', addressController, false, 50),
                            _buildTextField(
                                'Birth Date', birthDateController, true, 10),
                            _buildTextField(
                                'Username', usernameController, true, null),
                            _buildTextField(
                                'Email', emailController, false, 50),
                            _buildTextField(
                                'Phone', phoneController, false, 20),
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
                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            cityController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            postalCodeController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            birthDateController.text.isEmpty) {
                          showSnackBar(context,
                              'Please fill in all the fields!', secondaryColor);
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
                            postalCode: int.tryParse(postalCodeController.text),
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
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool readOnly, int? characters) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        maxLength: characters,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
