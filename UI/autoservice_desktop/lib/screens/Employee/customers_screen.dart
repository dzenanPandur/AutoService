import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/models/userModel.dart';
import 'package:autoservice_desktop/providers/ClientProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';
import 'vehicle_details_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({
    super.key,
  });

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final ClientProvider clientProvider = ClientProvider();
  List<userModel>? customers;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController searchByNameController = TextEditingController();
  TextEditingController searchByLocationController = TextEditingController();

  List<userModel> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBackgroundColor,
      ),
      body: Column(
        children: [
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
                    _searchCustomers();
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
                future: clientProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    customers = snapshot.data;

                    List<userModel> displayedCustomers =
                        _getDisplayedCustomers();

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
                                  'Name',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Location',
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
                                  'Customers',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              rowsPerPage: 5,
                              source: CustomerDataTableSource(
                                displayedCustomers,
                                clientProvider: clientProvider,
                                context: context,
                                refreshData: _refreshData,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void _searchCustomers() {
    String nameSearchText = searchByNameController.text.toLowerCase();
    String locationSearchText = searchByLocationController.text.toLowerCase();

    if (customers != null) {
      filteredCustomers = customers!
          .where((customer) =>
              '${customer.firstName} ${customer.lastName}'
                  .toLowerCase()
                  .contains(nameSearchText) &&
              customer.city.toLowerCase().contains(locationSearchText))
          .toList();

      String message;
      if (filteredCustomers.isNotEmpty) {
        message =
            '${filteredCustomers.length} customer(s) found for selected filters';
      } else {
        message = 'No customers found for selected filters';
      }

      showSnackBar(context, message);

      _refreshData();
    }
  }

  List<userModel> _getDisplayedCustomers() {
    if (filteredCustomers.isNotEmpty) {
      return filteredCustomers;
    } else {
      return customers ?? [];
    }
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }
}

void _showDetailsDialog(
  userModel customer,
  BuildContext context,
) {
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
              scrollable: true,
              backgroundColor: primaryBackgroundColor,
              title: const Text(
                'Loading...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else {
            List<VehicleModel> vehicles = [];
            if (snapshot.hasData) {
              vehicles = snapshot.data!;
            }

            return AlertDialog(
              elevation: 0,
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
                              buildRow("First Name", firstNameController, true,
                                  null, null),
                              buildRow("Last Name", lastNameController, true,
                                  null, null),
                              buildRow(
                                  "Gender", genderController, true, null, null),
                              buildRow(
                                  "City", cityController, true, null, null),
                              buildRow("Postal Code", postalCodeController,
                                  true, null, null),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow("Address", addressController, true, null,
                                  null),
                              buildRow("Birth Date", birthDateController, true,
                                  null, null),
                              buildRow("Username", usernameController, true,
                                  null, null),
                              buildRow(
                                  "Email", emailController, true, null, null),
                              buildRow("Phone Number", phoneController, true,
                                  null, null),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            horizontalMargin: 10,
                            headingRowColor:
                                MaterialStateProperty.all(secondaryColor),
                            arrowHeadColor: secondaryColor,
                            columns: [
                              DataColumn(
                                  label: Text(
                                'ID',
                                style: TextStyle(color: fontColor),
                              )),
                              DataColumn(
                                  label: Text(
                                'Vehicle',
                                style: TextStyle(color: fontColor),
                              )),
                              DataColumn(
                                  label: Text(
                                'Details',
                                style: TextStyle(color: fontColor),
                              )),
                            ],
                            header: Container(
                              color: primaryBackgroundColor,
                              child: const Center(
                                child: Text(
                                  'Customer Vehicles',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            rowsPerPage: 2,
                            source: CustomerVehiclesDataTableSource(
                              vehicles,
                              clientProvider,
                              context,
                            ),
                          ),
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
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
    this._vehicles,
    this.clientProvider,
    this.context,
  );

  @override
  DataRow getRow(int index) {
    final VehicleModel vehicle = _vehicles[index];

    return DataRow(
      cells: [
        DataCell(Text(vehicle.id.toString())),
        DataCell(Text("${vehicle.make} ${vehicle.model}")),
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white),
            ),
          ),
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
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white),
            ),
          ),
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
