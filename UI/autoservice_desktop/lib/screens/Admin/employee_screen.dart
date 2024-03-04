import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/UserProvider.dart';
import '../../models/userModel.dart';
import '../../globals.dart';
import '../../models/createUserModel.dart';
import '../../models/updateUserModel.dart';

class EmployeeScreen extends StatefulWidget {
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

  TextEditingController searchController = TextEditingController();

  List<userModel> filteredEmployees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee Management'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
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
                        filteredEmployees.isNotEmpty
                            ? filteredEmployees
                            : employees!;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('Full Name')),
                              DataColumn(label: Text('Gender')),
                              DataColumn(label: Text('Details')),
                              DataColumn(label: Text('Delete')),
                            ],
                            header: const Center(
                              child: Text('Employees'),
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
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
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
                                                      false),
                                                  buildRow(
                                                      "Last Name",
                                                      lastNameControllerAdd,
                                                      false),
                                                  buildDropdown(
                                                      "Gender",
                                                      ['Male', 'Female'],
                                                      genderControllerAdd),
                                                  buildRow("City",
                                                      cityControllerAdd, false),
                                                  buildRow(
                                                      "Postal Code",
                                                      postalCodeControllerAdd,
                                                      false),
                                                  buildRow(
                                                      "Address",
                                                      addressControllerAdd,
                                                      false),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildDatePicker(
                                                      "Birth Date",
                                                      context,
                                                      birthDateControllerAdd),
                                                  buildRow(
                                                      "Username",
                                                      usernameControllerAdd,
                                                      false),
                                                  buildRow(
                                                      "Email",
                                                      emailControllerAdd,
                                                      false),
                                                  buildRow(
                                                      "Phone Number",
                                                      phoneControllerAdd,
                                                      false),
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
                                          onPressed: () async {
                                            try {
                                              createUserModel request = createUserModel(
                                                  firstName: firstNameControllerAdd
                                                      .text,
                                                  lastName: lastNameControllerAdd
                                                      .text,
                                                  active: true,
                                                  gender:
                                                      genderControllerAdd.text ==
                                                              'Male'
                                                          ? 1
                                                          : 2,
                                                  city: cityControllerAdd.text,
                                                  address:
                                                      addressControllerAdd.text,
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
                                                  userName: usernameControllerAdd
                                                      .text,
                                                  roleId:
                                                      "9F4392A8-80BC-4C4F-9A6A-8D2C6C875F84",
                                                  password: passwordControllerAdd
                                                      .text,
                                                  passwordConfirm:
                                                      passwordConfirmControllerAdd
                                                          .text);

                                              var createdUser =
                                                  await userProvider
                                                      .create(request);
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

                                              Navigator.pop(context);
                                              _refreshData();
                                              print(
                                                  'Employee created: $createdUser');
                                            } catch (e) {
                                              print(
                                                  'Failed to create employee: $e');
                                            }
                                          },
                                          child: const Text('Add'),
                                        ),
                                        ElevatedButton(
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
                                            passwordConfirmControllerAdd.text =
                                                '';
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text('Add Employee'),
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
    String searchText = searchController.text.toLowerCase();

    if (employees != null) {
      filteredEmployees = employees!
          .where((employee) => '${employee.firstName} ${employee.lastName}'
              .toLowerCase()
              .contains(searchText))
          .toList();
      _refreshData();
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
                      buildRow("First Name", firstNameController, false),
                      buildRow("Last Name", lastNameController, false),
                      buildRow("Gender", genderController, true),
                      buildRow("City", cityController, false),
                      buildRow("Postal Code", postalCodeController, false),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow("Address", addressController, false),
                      buildRow("Birth Date", birthDateController, true),
                      buildRow("Username", usernameController, false),
                      buildRow("Email", emailController, false),
                      buildRow("Phone Number", phoneController, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actions: [
            ElevatedButton(
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
                  //_refreshData();
                } catch (e) {
                  print("Update failed: $e");
                }
                _refreshData();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
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
        DataCell(ElevatedButton(
          onPressed: () {
            showDetailsDialog(employee);
          },
          child: const Text('Details'),
        )),
        DataCell(ElevatedButton(
          onPressed: () {
            _showDeleteConfirmationDialog(employee);
          },
          child: const Text('Delete'),
        )),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(userModel employee) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryBackgroundColor,
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete ${employee.firstName} ${employee.lastName}?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userProvider.deleteUser(employee.userId);
                Navigator.of(context).pop();
                refreshData();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _employees.length;

  @override
  int get selectedRowCount => 0;
}
