// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/main.dart';
import 'package:autoservice_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../models/createUserModel.dart';
import '../models/storageService.dart';
import '../providers/UserProvider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String _selectedGender = '1';

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
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

  Future<void> _registerUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _postalCodeController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _birthDateController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty) {
      showSnackBar(context, 'Please fill in all the fields!', secondaryColor);
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      showSnackBar(context, 'Passwords do not match!', secondaryColor);
      return;
    }

    createUserModel user = createUserModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      gender: int.parse(_selectedGender),
      active: true,
      city: _cityController.text,
      address: _addressController.text,
      postalCode: int.parse(_postalCodeController.text),
      birthDate: _selectedDate,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      userName: _userNameController.text,
      roleId: "c6c0e6d5-1a11-4b25-96a2-1989e24a2d6d",
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );

    try {
      await UserProvider().create(user);

      StorageService? storageService = await authProvider.login(
          _userNameController.text, _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
              authProvider: authProvider, userId: storageService!.userId),
        ),
      );
      showSnackBar(
          context, 'Account succesfully created. Welcome!', accentColor);
    } catch (error) {
      showSnackBar(context, 'Failed to register user: $error', secondaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
        title: const Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'First Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _firstNameController,
                maxLength: 15,
              ),
              const SizedBox(height: 20),
              const Text(
                'Last Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _lastNameController,
                maxLength: 15,
              ),
              const SizedBox(height: 20),
              const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _userNameController,
                maxLength: 15,
              ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _emailController,
                maxLength: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold),
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
              const Text(
                'Birth Date',
                style: TextStyle(fontWeight: FontWeight.bold),
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
              const Text(
                'City',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _cityController,
                maxLength: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _addressController,
                maxLength: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Postal Code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _postalCodeController,
                maxLength: 10,
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _phoneNumberController,
                maxLength: 15,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Center(
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
                  onPressed: _registerUser,
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
