// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/UserProvider.dart';
import '../../models/userModel.dart';
import '../../globals.dart';
import '../../models/createUserModel.dart';
import '../../models/updateUserModel.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

final UserProvider userProvider = UserProvider();

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<userModel>? employees;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  String? _usernameError;
  String? _emailError;
  final List<GlobalKey<FormFieldState>> _fieldKeys = [];
  TextEditingController firstNameControllerAdd = TextEditingController();
  TextEditingController lastNameControllerAdd = TextEditingController();
  TextEditingController genderControllerAdd = TextEditingController();
  TextEditingController cityControllerAdd = TextEditingController();
  TextEditingController postalCodeControllerAdd = TextEditingController();
  TextEditingController addressControllerAdd = TextEditingController();
  TextEditingController birthDateControllerAdd = TextEditingController();
  TextEditingController usernameControllerAdd = TextEditingController();
  TextEditingController emailControllerAdd = TextEditingController();
  TextEditingController phoneControllerAdd = TextEditingController();
  TextEditingController passwordControllerAdd = TextEditingController();
  TextEditingController passwordConfirmControllerAdd = TextEditingController();

  TextEditingController searchByNameController = TextEditingController();
  TextEditingController searchByLocationController = TextEditingController();
  late bool emailExists;
  late bool usernameExists;
  List<userModel> filteredEmployees = [];
  Future<bool> _checkEmailExists(String email, String userId) async {
    try {
      return await UserProvider().checkEmailExists(email, userId);
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

  Future<bool> _checkUsernameExists(String username, String userId) async {
    try {
      return await UserProvider().checkUsernameExists(username, userId);
    } catch (error) {
      showSnackBar(context, "Error: $error", secondaryColor);
      return false;
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

  Future<void> _createUser() async {
    if (emailControllerAdd.text != "") {
      emailExists = await _checkEmailExists(
          emailControllerAdd.text, "00000000-0000-0000-0000-000000000000");
    }
    if (usernameControllerAdd.text != "") {
      usernameExists = await _checkUsernameExists(
          usernameControllerAdd.text, "00000000-0000-0000-0000-000000000000");
    }
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }
    String pickedDateString = birthDateControllerAdd.text;
    DateTime pickedDate = DateFormat('dd-MM-yyyy').parse(pickedDateString);

    try {
      createUserModel request = createUserModel(
          firstName: firstNameControllerAdd.text,
          lastName: lastNameControllerAdd.text,
          active: true,
          gender: genderControllerAdd.text == 'Male' ? 1 : 2,
          city: cityControllerAdd.text,
          address: addressControllerAdd.text,
          postalCode: int.tryParse(postalCodeControllerAdd.text) ?? 0,
          birthDate: pickedDate,
          email: emailControllerAdd.text,
          phoneNumber: phoneControllerAdd.text,
          userName: usernameControllerAdd.text,
          roleId: "9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84",
          password: passwordControllerAdd.text,
          passwordConfirm: passwordConfirmControllerAdd.text);

      await userProvider.create(request);
      firstNameControllerAdd.text = '';
      lastNameControllerAdd.text = '';
      genderControllerAdd.text = '';
      cityControllerAdd.text = '';
      postalCodeControllerAdd.text = '';
      addressControllerAdd.text = '';
      birthDateControllerAdd.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now());
      usernameControllerAdd.text = '';
      emailControllerAdd.text = '';
      phoneControllerAdd.text = '';
      passwordControllerAdd.text = '';
      passwordConfirmControllerAdd.text = '';

      Navigator.pop(context);
      _refreshData();
      showSnackBar(context, 'Successfully created employee.', accentColor);
    } catch (error) {
      showSnackBar(context, 'Failed to add employee. $error', secondaryColor);
    }
  }

  @override
  void initState() {
    _usernameError = null;
    _emailError = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          title: const Text(
            'Employee Management',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchByNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchByLocationController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Location',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    _searchEmployees();
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<userModel>>(
                future: userProvider.getAllEmployees(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    employees = snapshot.data;

                    List<userModel> displayedEmployees =
                        _getDisplayedEmployees();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PaginatedDataTable(
                              headingRowColor:
                                  MaterialStateProperty.all(secondaryColor),
                              arrowHeadColor: secondaryColor,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'Full Name',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Gender',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Is Active',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Details',
                                  style: TextStyle(color: fontColor),
                                )),
                              ],
                              header: const Center(
                                child: Text(
                                  'Employees',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              rowsPerPage: 5,
                              source: EmployeeDataTableSource(
                                displayedEmployees,
                                userProvider: userProvider,
                                context: context,
                                showDetailsDialog: _showDetailsDialog,
                                refreshData: _refreshData,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25, horizontal: 30),
                                      backgroundColor: secondaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              elevation: 0,
                                              backgroundColor:
                                                  primaryBackgroundColor,
                                              title: const Text(
                                                'Add Employee',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: SingleChildScrollView(
                                                child: Form(
                                                  key: _formKey,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            buildRow(
                                                                "First Name",
                                                                firstNameControllerAdd,
                                                                false,
                                                                null,
                                                                20,
                                                                validator:
                                                                    _validateName,
                                                                key:
                                                                    _addFieldKey()),
                                                            buildRow(
                                                                "Last Name",
                                                                lastNameControllerAdd,
                                                                false,
                                                                null,
                                                                20,
                                                                validator:
                                                                    _validateName,
                                                                key:
                                                                    _addFieldKey()),
                                                            buildDropdown(
                                                              "Gender",
                                                              [
                                                                'Male',
                                                                'Female'
                                                              ],
                                                              genderControllerAdd,
                                                              validator:
                                                                  _validateGender,
                                                            ),
                                                            buildRow(
                                                                "City",
                                                                cityControllerAdd,
                                                                false,
                                                                null,
                                                                20,
                                                                validator:
                                                                    _validateCity,
                                                                key:
                                                                    _addFieldKey()),
                                                            buildRow(
                                                                "Postal Code",
                                                                postalCodeControllerAdd,
                                                                false,
                                                                null,
                                                                10,
                                                                validator:
                                                                    _validatePostalCode,
                                                                key:
                                                                    _addFieldKey()),
                                                            buildRow(
                                                                "Phone Number",
                                                                phoneControllerAdd,
                                                                false,
                                                                null,
                                                                20,
                                                                validator:
                                                                    _validatePhone,
                                                                key:
                                                                    _addFieldKey(),
                                                                helperText:
                                                                    'Example: +38761234567 \n                 061234567'),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            buildRow(
                                                                "Username",
                                                                usernameControllerAdd,
                                                                false,
                                                                null,
                                                                15,
                                                                validator:
                                                                    _validateUsername,
                                                                errorText:
                                                                    _usernameError,
                                                                key:
                                                                    _addFieldKey(),
                                                                onChanged:
                                                                    (value) {}),
                                                            buildRow(
                                                                "Email",
                                                                emailControllerAdd,
                                                                false,
                                                                null,
                                                                50,
                                                                validator:
                                                                    _validateEmail,
                                                                errorText:
                                                                    _emailError,
                                                                key:
                                                                    _addFieldKey(),
                                                                onChanged:
                                                                    (value) {}),
                                                            buildDatePicker(
                                                                "Birth Date",
                                                                context,
                                                                birthDateControllerAdd,
                                                                validator:
                                                                    _validateBirthDate),
                                                            buildRow(
                                                                "Address",
                                                                addressControllerAdd,
                                                                false,
                                                                null,
                                                                50,
                                                                validator:
                                                                    _validateAddress,
                                                                key:
                                                                    _addFieldKey()),
                                                            buildPasswordRow(
                                                                "Password",
                                                                passwordControllerAdd,
                                                                validator:
                                                                    validatePassword),
                                                            buildPasswordRow(
                                                                "Password Confirm",
                                                                passwordConfirmControllerAdd,
                                                                validator: (value) =>
                                                                    validatePasswordConfirm(
                                                                        value,
                                                                        passwordControllerAdd
                                                                            .text)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              actions: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                    backgroundColor:
                                                        secondaryColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: const BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    _createUser();
                                                  },
                                                  child: const Text(
                                                    'Add',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                    backgroundColor:
                                                        secondaryColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: const BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    firstNameControllerAdd
                                                        .text = '';
                                                    lastNameControllerAdd.text =
                                                        '';
                                                    genderControllerAdd.text =
                                                        '';
                                                    cityControllerAdd.text = '';
                                                    postalCodeControllerAdd
                                                        .text = '';
                                                    addressControllerAdd.text =
                                                        '';
                                                    birthDateControllerAdd
                                                        .text = DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(DateTime.now());
                                                    usernameControllerAdd.text =
                                                        '';
                                                    emailControllerAdd.text =
                                                        '';
                                                    phoneControllerAdd.text =
                                                        '';
                                                    passwordControllerAdd.text =
                                                        '';
                                                    passwordConfirmControllerAdd
                                                        .text = '';
                                                    _usernameError = null;
                                                    _emailError = null;
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text(
                                      'Add Employee',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ]));
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
      return 'Invalid phone number format \nEx: +38761234567 \n       061234567';
    }

    return null;
  }

  void _searchEmployees() {
    String nameSearchText = searchByNameController.text.toLowerCase();
    String locationSearchText = searchByLocationController.text.toLowerCase();

    if (employees != null) {
      List<String> locationParts =
          locationSearchText.split(',').map((part) => part.trim()).toList();

      filteredEmployees = employees!.where((employee) {
        bool nameMatches = '${employee.firstName} ${employee.lastName}'
            .toLowerCase()
            .contains(nameSearchText);
        bool locationMatches = locationParts.every((part) =>
            employee.city.toLowerCase().contains(part) ||
            employee.address.toLowerCase().contains(part));
        return nameMatches && locationMatches;
      }).toList();

      String message;
      if (filteredEmployees.isNotEmpty) {
        message =
            '${filteredEmployees.length} employee(s) found for selected filters';
      } else {
        message = 'No employees found for selected filters';
      }

      showSnackBar(context, message, accentColor);

      _refreshData();
    }
  }

  List<userModel> _getDisplayedEmployees() {
    if (filteredEmployees.isNotEmpty) {
      return filteredEmployees;
    } else {
      return employees ?? [];
    }
  }

  void _showDetailsDialog(userModel employee) {
    TextEditingController firstNameController =
        TextEditingController(text: employee.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: employee.lastName);
    TextEditingController genderController =
        TextEditingController(text: employee.gender == 1 ? 'Male' : 'Female');
    TextEditingController cityController =
        TextEditingController(text: employee.city);
    TextEditingController postalCodeController =
        TextEditingController(text: employee.postalCode.toString());
    TextEditingController addressController =
        TextEditingController(text: employee.address);
    TextEditingController birthDateController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(employee.birthDate));
    TextEditingController usernameController =
        TextEditingController(text: employee.username);
    TextEditingController emailController =
        TextEditingController(text: employee.email);
    TextEditingController phoneController =
        TextEditingController(text: employee.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
          title: const Text(
            'Employee Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildRow(
                            "First Name", firstNameController, false, null, 20,
                            validator: _validateName),
                        buildRow(
                            "Last Name", lastNameController, false, null, 20,
                            validator: _validateName),
                        buildRow("Gender", genderController, true, null, null,
                            validator: _validateGender),
                        buildRow("City", cityController, false, null, 15,
                            validator: _validateCity),
                        buildRow("Postal Code", postalCodeController, false,
                            null, 10,
                            validator: _validatePostalCode),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("Address", addressController, false, null, 50,
                            validator: _validateAddress),
                        buildRow(
                            "Username", usernameController, false, null, 20,
                            validator: _validateUsername),
                        buildRow(
                            "Birth Date", birthDateController, true, null, null,
                            validator: _validateBirthDate),
                        buildRow("Email", emailController, false, null, 50,
                            validator: _validateEmail),
                        buildRow(
                            "Phone Number", phoneController, false, null, 50,
                            validator: _validatePhone,
                            helperText:
                                'Example: +38761234567 \n                 061234567'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              onPressed: () async {
                if (emailController.text != "") {
                  emailExists = await _checkEmailExists(
                      emailController.text, employee.userId);
                }
                if (usernameController.text != "") {
                  usernameExists = await _checkUsernameExists(
                      usernameController.text, employee.userId);
                }
                if (!_formKey.currentState!.validate()) {
                  _scrollToFirstError();
                  return;
                }
                try {
                  updateUserModel update = updateUserModel(
                    id: employee.userId,
                    email: emailController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    phoneNumber: phoneController.text,
                    address: addressController.text,
                    city: cityController.text,
                    postalCode: int.tryParse(postalCodeController.text),
                    userName: usernameController.text,
                    active: employee.active,
                    gender: employee.gender,
                  );
                  await userProvider.updateUser(update);
                  Navigator.pop(context);
                  showSnackBar(
                      context, 'Successfully saved changes.', accentColor);
                } catch (e) {
                  showSnackBar(
                      context, 'Failed to save changes. $e', secondaryColor);
                }
                _refreshData();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }
}

class EmployeeDataTableSource extends DataTableSource {
  final List<userModel> _employees;
  final Function(userModel) showDetailsDialog;
  final UserProvider userProvider;
  final BuildContext context;
  final Function refreshData;

  EmployeeDataTableSource(this._employees,
      {required this.showDetailsDialog,
      required this.userProvider,
      required this.context,
      required this.refreshData});

  @override
  DataRow getRow(int index) {
    final userModel employee = _employees[index];
    return DataRow(
      cells: [
        DataCell(Text('${employee.firstName} ${employee.lastName}')),
        DataCell(Text(employee.gender == 1 ? 'Male' : 'Female')),
        DataCell(Checkbox(
          value: employee.active,
          onChanged: (bool? value) async {
            employee.active = value ?? false;
            await userProvider.updateUserActiveStatus(employee.userId, value!);

            refreshData();

            showSnackBar(
                context, 'Employee status updated successfully!', accentColor);
          },
        )),
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: () {
            showDetailsDialog(employee);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _employees.length;

  @override
  int get selectedRowCount => 0;
}
