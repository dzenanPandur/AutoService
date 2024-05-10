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

  List<userModel> filteredEmployees = [];

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

                    return Column(
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
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            child: ElevatedButton(
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
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        elevation: 0,
                                        backgroundColor: primaryBackgroundColor,
                                        title: const Text(
                                          'Add Employee',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    buildRow(
                                                        "First Name",
                                                        firstNameControllerAdd,
                                                        false,
                                                        null,
                                                        20),
                                                    buildRow(
                                                        "Last Name",
                                                        lastNameControllerAdd,
                                                        false,
                                                        null,
                                                        20),
                                                    buildDropdown(
                                                        "Gender",
                                                        ['Male', 'Female'],
                                                        genderControllerAdd),
                                                    buildRow(
                                                        "City",
                                                        cityControllerAdd,
                                                        false,
                                                        null,
                                                        20),
                                                    buildRow(
                                                        "Postal Code",
                                                        postalCodeControllerAdd,
                                                        false,
                                                        null,
                                                        10),
                                                    buildRow(
                                                        "Address",
                                                        addressControllerAdd,
                                                        false,
                                                        null,
                                                        50),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    buildRow(
                                                        "Username",
                                                        usernameControllerAdd,
                                                        false,
                                                        null,
                                                        15),
                                                    buildRow(
                                                        "Email",
                                                        emailControllerAdd,
                                                        false,
                                                        null,
                                                        15),
                                                    buildDatePicker(
                                                        "Birth Date",
                                                        context,
                                                        birthDateControllerAdd),
                                                    buildRow(
                                                        "Phone Number",
                                                        phoneControllerAdd,
                                                        false,
                                                        null,
                                                        20),
                                                    buildPasswordRow("Password",
                                                        passwordControllerAdd),
                                                    buildPasswordRow(
                                                        "Password Confirm",
                                                        passwordConfirmControllerAdd),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 20),
                                              backgroundColor: secondaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () async {
                                              try {
                                                createUserModel request = createUserModel(
                                                    firstName:
                                                        firstNameControllerAdd
                                                            .text,
                                                    lastName:
                                                        lastNameControllerAdd
                                                            .text,
                                                    active: true,
                                                    gender: genderControllerAdd
                                                                .text ==
                                                            'Male'
                                                        ? 1
                                                        : 2,
                                                    city:
                                                        cityControllerAdd.text,
                                                    address: addressControllerAdd
                                                        .text,
                                                    postalCode:
                                                        int.tryParse(postalCodeControllerAdd.text) ??
                                                            0,
                                                    birthDate: DateTime.parse(
                                                        birthDateControllerAdd
                                                            .text),
                                                    email:
                                                        emailControllerAdd.text,
                                                    phoneNumber:
                                                        phoneControllerAdd.text,
                                                    userName:
                                                        usernameControllerAdd
                                                            .text,
                                                    roleId: "9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84",
                                                    password: passwordControllerAdd.text,
                                                    passwordConfirm: passwordConfirmControllerAdd.text);

                                                await userProvider
                                                    .create(request);
                                                firstNameControllerAdd.text =
                                                    '';
                                                lastNameControllerAdd.text = '';
                                                genderControllerAdd.text = '';
                                                cityControllerAdd.text = '';
                                                postalCodeControllerAdd.text =
                                                    '';
                                                addressControllerAdd.text = '';
                                                birthDateControllerAdd.text =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(DateTime.now());
                                                usernameControllerAdd.text = '';
                                                emailControllerAdd.text = '';
                                                phoneControllerAdd.text = '';
                                                passwordControllerAdd.text = '';
                                                passwordConfirmControllerAdd
                                                    .text = '';

                                                Navigator.pop(context);
                                                _refreshData();
                                                showSnackBar(context,
                                                    'Successfully created employee.');
                                              } catch (error) {
                                                showSnackBar(context,
                                                    'Failed to add employee. $error');
                                              }
                                            },
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 20),
                                              backgroundColor: secondaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              firstNameControllerAdd.text = '';
                                              lastNameControllerAdd.text = '';
                                              genderControllerAdd.text = '';
                                              cityControllerAdd.text = '';
                                              postalCodeControllerAdd.text = '';
                                              addressControllerAdd.text = '';
                                              birthDateControllerAdd.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now());
                                              usernameControllerAdd.text = '';
                                              emailControllerAdd.text = '';
                                              phoneControllerAdd.text = '';
                                              passwordControllerAdd.text = '';
                                              passwordConfirmControllerAdd
                                                  .text = '';
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(fontSize: 15),
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
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          )
        ]));
  }

  void _searchEmployees() {
    String nameSearchText = searchByNameController.text.toLowerCase();
    String locationSearchText = searchByLocationController.text.toLowerCase();

    if (employees != null) {
      filteredEmployees = employees!
          .where((employee) =>
              '${employee.firstName} ${employee.lastName}'
                  .toLowerCase()
                  .contains(nameSearchText) &&
              employee.city.toLowerCase().contains(locationSearchText))
          .toList();

      String message;
      if (filteredEmployees.isNotEmpty) {
        message =
            '${filteredEmployees.length} employee(s) found for selected filters';
      } else {
        message = 'No employees found for selected filters';
      }

      showSnackBar(context, message);

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
        text: DateFormat('yyyy-MM-dd').format(employee.birthDate));
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
          content: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildRow(
                          "First Name", firstNameController, false, null, 20),
                      buildRow(
                          "Last Name", lastNameController, false, null, 20),
                      buildRow("Gender", genderController, true, null, null),
                      buildRow("City", cityController, false, null, 15),
                      buildRow(
                          "Postal Code", postalCodeController, false, null, 10),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow("Address", addressController, false, null, 50),
                      buildRow("Username", usernameController, false, null, 20),
                      buildRow(
                          "Birth Date", birthDateController, true, null, null),
                      buildRow("Email", emailController, false, null, 50),
                      buildRow(
                          "Phone Number", phoneController, false, null, 50),
                    ],
                  ),
                ),
              ],
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
                    active: true,
                    //gender: 2,
                  );
                  await userProvider.updateUser(update);
                  Navigator.pop(context);
                  showSnackBar(context, 'Successfully saved changes.');
                  //_refreshData();
                } catch (e) {
                  // print("Update failed: $e");
                  showSnackBar(context, 'Failed to save changes. $e');
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

            showSnackBar(context, 'Employee status updated successfully!');
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
