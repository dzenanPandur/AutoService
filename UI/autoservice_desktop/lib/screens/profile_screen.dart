import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/UserProvider.dart';
import '../models/userModel.dart';
import '../models/storageService.dart';
import '../models/updateUserModel.dart';

const StorageService? storageService = null;
final UserProvider userProvider = UserProvider();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storageService =
        ModalRoute.of(context)!.settings.arguments as StorageService?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: FutureBuilder(
        future: UserProvider().getByUsername(storageService!.username),
        builder: (context, AsyncSnapshot<userModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('User not found');
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
                text: DateFormat('yyyy-MM-dd').format(user.birthDate));
            TextEditingController usernameController =
                TextEditingController(text: user.username);
            TextEditingController emailController =
                TextEditingController(text: user.email);
            TextEditingController phoneController =
                TextEditingController(text: user.phoneNumber);
            TextEditingController passwordController = TextEditingController();
            TextEditingController passwordConfirmController =
                TextEditingController();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTextField(
                            'First Name', firstNameController, false),
                        _buildTextField('Last Name', lastNameController, false),
                        _buildTextField('Gender', genderController, true),
                        _buildTextField('City', cityController, false),
                        _buildTextField(
                            'Postal Code', postalCodeController, false),
                        _buildTextField('Address', addressController, false),
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
                            'Birth Date', birthDateController, true),
                        _buildTextField('Username', usernameController, true),
                        _buildTextField('Email', emailController, false),
                        _buildTextField('Phone', phoneController, false),
                        _buildPasswordField('Password', passwordController),
                        _buildPasswordField(
                            'Password Confirm', passwordConfirmController),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                updateUserModel update = updateUserModel(
                                  id: user.userId,
                                  email: emailController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  phoneNumber: phoneController.text,
                                  address: addressController.text,
                                  city: cityController.text,
                                  active: user.active,
                                  postalCode:
                                      int.tryParse(postalCodeController.text),
                                );
                                await userProvider.updateUser(update);
                              } catch (e) {
                                print("Update failed: $e");
                              }
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(16.0),
                              ),
                            ),
                            child: const Text('Save Changes',
                                style: TextStyle(fontSize: 18.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: editable,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity * 0.25,
        child: TextField(
          readOnly: true,
          obscureText: true,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            enabledBorder: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
