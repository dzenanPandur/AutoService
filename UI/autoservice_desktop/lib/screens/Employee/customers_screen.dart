import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/models/userModel.dart';
import 'package:autoservice_desktop/providers/ClientProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';
import 'vehicle_details_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final ClientProvider clientProvider = ClientProvider();
  List<userModel>? customers;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<userModel>>(
                future: clientProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    customers = snapshot.data;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Location')),
                              //DataColumn(label: Text('Cars owned')),
                              DataColumn(label: Text('Details')),
                            ],
                            header: const Center(
                              child: Text('Customers'),
                            ),
                            rowsPerPage: 5,
                            source: CustomerDataTableSource(
                              customers!,
                              clientProvider: clientProvider,
                              context: context,
                              //showDetailsDialog: _showDetailsDialog,
                              refreshData: _refreshData,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }
}

void _showDetailsDialog(userModel customer, BuildContext context) {
  TextEditingController firstNameController =
      TextEditingController(text: customer.firstName);
  TextEditingController lastNameController =
      TextEditingController(text: customer.lastName);
  TextEditingController genderController =
      TextEditingController(text: customer.gender == 1 ? 'Male' : 'Female');
  TextEditingController cityController =
      TextEditingController(text: customer.city);
  TextEditingController postalCodeController =
      TextEditingController(text: customer.postalCode.toString());
  TextEditingController addressController =
      TextEditingController(text: customer.address);
  TextEditingController birthDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(customer.birthDate));
  TextEditingController usernameController =
      TextEditingController(text: customer.username);
  TextEditingController emailController =
      TextEditingController(text: customer.email);
  TextEditingController phoneController =
      TextEditingController(text: customer.phoneNumber);

  final ClientProvider clientProvider = ClientProvider();

  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<List<VehicleModel>>(
        future: clientProvider.getAllVehiclesByClient(
          customer.userId.toString(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              backgroundColor: primaryBackgroundColor,
              title: const Text(
                'Loading...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              backgroundColor: primaryBackgroundColor,
              title: const Text(
                'Error loading vehicles',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text('Error: ${snapshot.error}'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          } else {
            List<VehicleModel> vehicles = snapshot.data!;

            return AlertDialog(
              backgroundColor: primaryBackgroundColor,
              title: const Text(
                'Customer Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              buildRow("First Name", firstNameController, true),
                              buildRow("Last Name", lastNameController, true),
                              buildRow("Gender", genderController, true),
                              buildRow("City", cityController, true),
                              buildRow(
                                  "Postal Code", postalCodeController, true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow("Address", addressController, true),
                              buildRow("Birth Date", birthDateController, true),
                              buildRow("Username", usernameController, true),
                              buildRow("Email", emailController, true),
                              buildRow("Phone Number", phoneController, true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //const SizedBox(height: 15),
                    // Adding the new table right below "Phone Number"
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: PaginatedDataTable(
                        horizontalMargin: 10,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Vehicle')),
                          DataColumn(label: Text('Details')),
                        ],
                        //header: const Center(
                        // child: Text('Customer Vehicles'),
                        //),
                        rowsPerPage: 2,
                        source: CustomerVehiclesDataTableSource(
                          vehicles,
                          clientProvider,
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          }
        },
      );
    },
  );
}

class CustomerVehiclesDataTableSource extends DataTableSource {
  final List<VehicleModel> _vehicles;
  final ClientProvider clientProvider;
  final BuildContext context;

  CustomerVehiclesDataTableSource(
      this._vehicles, this.clientProvider, this.context);

  @override
  DataRow getRow(int index) {
    final VehicleModel vehicle = _vehicles[index];

    return DataRow(
      cells: [
        DataCell(Text(vehicle.id.toString())),
        DataCell(Text("${vehicle.make} ${vehicle.model}")),
        DataCell(ElevatedButton(
          onPressed: () {
            _openVehicleDetailsScreen(vehicle);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  void _openVehicleDetailsScreen(VehicleModel vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsScreen(vehicle: vehicle),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _vehicles.length;

  @override
  int get selectedRowCount => 0;
}

class CustomerDataTableSource extends DataTableSource {
  final List<userModel> _customers;
  final ClientProvider clientProvider;
  final BuildContext context;
  final Function refreshData;

  CustomerDataTableSource(
    this._customers, {
    required this.refreshData,
    required this.clientProvider,
    required this.context,
  });
  @override
  DataRow getRow(int index) {
    final userModel customer = _customers[index];

    return DataRow(
      cells: [
        DataCell(Text("${customer.firstName} ${customer.lastName}")),
        DataCell(Text("${customer.city}, ${customer.address}")),
        //DataCell(Text("2")), //temp
        DataCell(ElevatedButton(
          onPressed: () {
            _showDetailsDialog(customer, context);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _customers.length;

  @override
  int get selectedRowCount => 0;
}
