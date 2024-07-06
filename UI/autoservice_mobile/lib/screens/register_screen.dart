// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/main.dart';
import 'package:autoservice_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/createUserModel.dart';
import '../models/storageService.dart';
import '../providers/UserProvider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final List<GlobalKey<FormFieldState>> _fieldKeys = [];
  String? _usernameError;
  String? _emailError;
  String? phoneHelperText = 'Example: +38761234567 or 061234567';
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
  late bool emailExists;
  late bool usernameExists;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _usernameError = null;
    _emailError = null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      return await UserProvider()
          .checkEmailExists(email, "00000000-0000-0000-0000-000000000000");
    } catch (error) {
      showSnackBar(context, "Error: $error", secondaryColor);
      return false;
    }
  }

  Future<bool> _checkUsernameExists(String username) async {
    try {
      return await UserProvider().checkUsernameExists(
          username, "00000000-0000-0000-0000-000000000000");
    } catch (error) {
      showSnackBar(context, "Error: $error", secondaryColor);
      return false;
    }
  }

  GlobalKey<FormFieldState> _addFieldKey() {
    final key = GlobalKey<FormFieldState>();
    _fieldKeys.add(key);
    return key;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        fieldHintText: "dd/mm/yyyy",
        locale: const Locale("en", "GB"),
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
    if (value.length < 5) {
      return 'Username too short \nMinimum length 5 characters';
    }
    if (usernameExists) return 'Username is already taken';
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password too short \nMinimum length 6 characters';
    }
    return null;
  }

  String? validatePasswordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _registerUser() async {
    if (_emailController.text != "") {
      emailExists = await _checkEmailExists(_emailController.text);
    }
    if (_userNameController.text != "") {
      usernameExists = await _checkUsernameExists(_userNameController.text);
    }
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }

    try {
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
          context, 'Account successfully created. Welcome!', accentColor);
    } catch (error) {
      showSnackBar(context, 'Failed to create profile: $error', secondaryColor);
    }
  }

  void _scrollToFirstError() {
    for (final key in _fieldKeys) {
      if (key.currentState?.hasError ?? false) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.5,
          duration: const Duration(milliseconds: 500),
        );
        return;
      }
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
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    validator: _validateName,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Last Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    maxLength: 15,
                    validator: _validateName,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _userNameController,
                    maxLength: 15,
                    decoration: InputDecoration(errorText: _usernameError),
                    validator: _validateUsername,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                      controller: _emailController,
                      maxLength: 50,
                      decoration: InputDecoration(errorText: _emailError),
                      validator: _validateEmail,
                      key: _addFieldKey()),
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
                      validator: _validateGender,
                      key: _addFieldKey()),
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
                          validator: _validateBirthDate,
                          key: _addFieldKey(),
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
                    validator: _validateCity,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _addressController,
                    maxLength: 100,
                    validator: _validateAddress,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Postal Code',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _postalCodeController,
                    maxLength: 10,
                    validator: _validatePostalCode,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    maxLength: 15,
                    validator: _validatePhone,
                    decoration: InputDecoration(helperText: phoneHelperText),
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: validatePassword,
                    key: _addFieldKey(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Confirm Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: true,
                    validator: (value) => validatePasswordConfirm(
                        value, _passwordController.text),
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
        ),
      ),
    );
  }
}
