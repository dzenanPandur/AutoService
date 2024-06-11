// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/models/userModel.dart';
import 'package:autoservice_mobile/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import '../providers/ClientProvider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthDateController;

  String _selectedGender = '1';

  late DateTime _selectedDate;

  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeDataFuture = _initializeData();
    _selectedDate = DateTime.now();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final client = await ClientProvider().GetById(widget.userId);

      setState(() {
        _firstNameController = TextEditingController(text: client.firstName);
        _lastNameController = TextEditingController(text: client.lastName);
        _userNameController = TextEditingController(text: client.username);
        _emailController = TextEditingController(text: client.email);
        _cityController = TextEditingController(text: client.city);
        _addressController = TextEditingController(text: client.address);
        _postalCodeController =
            TextEditingController(text: client.postalCode.toString());
        _phoneNumberController =
            TextEditingController(text: client.phoneNumber);
        _birthDateController =
            TextEditingController(text: _formatDate(client.birthDate));
        _selectedGender = client.gender.toString();
      });
    } catch (error) {
      showSnackBar(context, 'Error fetching user data: $error', secondaryColor);
    }
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _postalCodeController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _birthDateController.text.isEmpty) {
      showSnackBar(context, 'Please fill in all the fields!', secondaryColor);
      return;
    }
    userModel updatedClient = userModel(
      userId: widget.userId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      active: true,
      username: _userNameController.text,
      role: "c6c0e6d5-1a11-4b25-96a2-1989e24a2d6d",
      email: _emailController.text,
      city: _cityController.text,
      address: _addressController.text,
      postalCode: int.parse(_postalCodeController.text),
      phoneNumber: _phoneNumberController.text,
      birthDate: _selectedDate,
      gender: int.parse(_selectedGender),
    );

    try {
      await UserProvider().update(updatedClient);

      showSnackBar(context, 'Profile updated successfully', accentColor);
    } catch (error) {
      showSnackBar(context, 'Failed to update profile: $error', secondaryColor);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = _formatDate(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: secondaryColor,
          title: Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: const Text('Profile'),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<void>(
                future: _initializeDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _firstNameController,
                            maxLength: 15,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Last Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _lastNameController,
                            maxLength: 15,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Username',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _userNameController,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _emailController,
                            maxLength: 50,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Gender',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: '1',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text('Female'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Birth Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _birthDateController,
                                  readOnly: true,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _selectDate(context),
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'City',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _cityController,
                            maxLength: 50,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _addressController,
                            maxLength: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Postal Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _postalCodeController,
                            maxLength: 10,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                          TextFormField(
                            controller: _phoneNumberController,
                            maxLength: 15,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  backgroundColor: secondaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                onPressed: _updateProfile,
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })));
  }
}
