// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/models/userModel.dart';
import 'package:autoservice_desktop/providers/ClientProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../globals.dart';
import '../../models/Employee/requestModel.dart';
import '../../providers/RequestProvider.dart';
import 'vehicle_details_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  Future<void> _fetchCustomers() async {
    customers = await clientProvider.getAll();
    filteredCustomers = customers ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
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
                                  onVehicleUpdated: _fetchCustomers),
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  final pdf = pw.Document();

                  List<RequestModel> requests =
                      await RequestProvider().getAll();

                  double calculateAverageAmountSpent(
                      List<RequestModel> requests) {
                    List<RequestModel> completedRequests =
                        requests.where((r) => r.status == 'Completed').toList();

                    double totalSpent = completedRequests.fold(
                      0,
                      (sum, item) => sum + (item.totalCost ?? 0),
                    );

                    int numberOfCustomers = completedRequests
                        .map((r) => r.clientName)
                        .toSet()
                        .length;

                    if (numberOfCustomers == 0) return 0;

                    return totalSpent / numberOfCustomers;
                  }

                  Map<String, int> calculateTotalRequestsPerCustomer(
                    List<RequestModel> requests,
                  ) {
                    Map<String, int> customerRequestCount = {};
                    for (var request in requests) {
                      if (request.status != 'Completed') continue;
                      customerRequestCount[request.clientName] =
                          (customerRequestCount[request.clientName] ?? 0) + 1;
                    }
                    var sortedEntries = customerRequestCount.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));
                    return Map.fromEntries(sortedEntries.take(5));
                  }

                  Map<String, Duration> calculateAverageFulfillmentTime(
                    List<RequestModel> requests,
                  ) {
                    Map<String, Duration> customerFulfillmentTime = {};
                    Map<String, int> customerRequestCount = {};
                    for (var request in requests) {
                      if (request.status != 'Completed') continue;
                      Duration fulfillmentTime = request.dateCompleted
                          .difference(request.dateRequested);
                      customerFulfillmentTime[request.clientName] =
                          (customerFulfillmentTime[request.clientName] ??
                                  Duration.zero) +
                              fulfillmentTime;
                      customerRequestCount[request.clientName] =
                          (customerRequestCount[request.clientName] ?? 0) + 1;
                    }

                    Map<String, Duration> customerAverageFulfillmentTime = {};
                    customerFulfillmentTime.forEach((key, value) {
                      customerAverageFulfillmentTime[key] =
                          value ~/ customerRequestCount[key]!;
                    });

                    var sortedEntries = customerAverageFulfillmentTime.entries
                        .toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                    return Map.fromEntries(sortedEntries.take(5));
                  }

                  double calculateCustomerRetentionRate(
                    List<RequestModel> requests,
                  ) {
                    Set<String> uniqueCustomers =
                        requests.map((r) => r.clientName).toSet();
                    Set<String> returningCustomers = requests
                        .where((r) =>
                            requests
                                .where((r2) => r2.clientName == r.clientName)
                                .length >
                            1)
                        .map((r) => r.clientName)
                        .toSet();
                    return (returningCustomers.length /
                            uniqueCustomers.length) *
                        100;
                  }

                  Map<String, int> calculateNewVsReturningCustomers(
                    List<RequestModel> requests,
                  ) {
                    Set<String> newCustomers = {};
                    Set<String> returningCustomers = {};
                    for (var request in requests) {
                      if (newCustomers.contains(request.clientName) ||
                          returningCustomers.contains(request.clientName)) {
                        returningCustomers.add(request.clientName);
                        newCustomers.remove(request.clientName);
                      } else {
                        newCustomers.add(request.clientName);
                      }
                    }
                    return {
                      "NewCustomers": newCustomers.length,
                      "ReturningCustomers": returningCustomers.length,
                    };
                  }

                  List<MapEntry<String, double>>
                      calculateTopCustomersByAmountSpent(
                    List<RequestModel> requests,
                  ) {
                    Map<String, double> customerTotalSpent = {};
                    for (var request in requests) {
                      if (request.status != 'Completed') continue;
                      customerTotalSpent[request.clientName] =
                          (customerTotalSpent[request.clientName] ?? 0) +
                              (request.totalCost ?? 0);
                    }
                    var sortedEntries = customerTotalSpent.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));
                    return sortedEntries.take(5).toList();
                  }

                  double averageAmountSpent =
                      calculateAverageAmountSpent(requests);
                  Map<String, int> totalRequestsPerCustomer =
                      calculateTotalRequestsPerCustomer(requests);
                  Map<String, Duration> averageFulfillmentTime =
                      calculateAverageFulfillmentTime(requests);
                  double customerRetentionRate =
                      calculateCustomerRetentionRate(requests);
                  Map<String, int> newVsReturningCustomers =
                      calculateNewVsReturningCustomers(requests);
                  List<MapEntry<String, double>> topCustomersByAmountSpent =
                      calculateTopCustomersByAmountSpent(requests);

                  pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Center(
                          child: pw.Text(
                            'AutoService',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Customers report generated at: ${DateFormat('dd.MM.yyyy').format(DateTime.now())} at ${DateFormat('HH:mm').format(DateTime.now())}',
                          style: const pw.TextStyle(fontSize: 16),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Average Amount of Money Spent per Customer: ${averageAmountSpent.toStringAsFixed(2)} KM',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.Text(
                          'Customer Retention Rate: ${customerRetentionRate.toStringAsFixed(2)}%',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.Text(
                          'New vs. Returning Customers: New: ${newVsReturningCustomers["NewCustomers"]}, Returning: ${newVsReturningCustomers["ReturningCustomers"]}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Top 5 Customers by Average Fulfillment Time:',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TableHelper.fromTextArray(
                          headers: [
                            'Customer Name',
                            'Average Fulfillment Time'
                          ],
                          data: averageFulfillmentTime.entries
                              .map((entry) =>
                                  [entry.key, '${entry.value.inDays} days'])
                              .toList(),
                          border: pw.TableBorder.all(),
                          cellAlignment: pw.Alignment.centerLeft,
                          headerStyle:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          cellStyle: const pw.TextStyle(fontSize: 12),
                          cellPadding: const pw.EdgeInsets.all(8),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Top 5 Customers by Total Completed Requests:',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TableHelper.fromTextArray(
                          headers: ['Customer Name', 'Total Requests'],
                          data: totalRequestsPerCustomer.entries
                              .map((entry) =>
                                  [entry.key, entry.value.toString()])
                              .toList(),
                          border: pw.TableBorder.all(),
                          cellAlignment: pw.Alignment.centerLeft,
                          headerStyle:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          cellStyle: const pw.TextStyle(fontSize: 12),
                          cellPadding: const pw.EdgeInsets.all(8),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Top 5 Customers by Amount Spent:',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TableHelper.fromTextArray(
                          headers: ['Customer Name', 'Amount Spent'],
                          data: topCustomersByAmountSpent
                              .map((entry) => [
                                    entry.key,
                                    '${entry.value.toStringAsFixed(2)} KM'
                                  ])
                              .toList(),
                          border: pw.TableBorder.all(),
                          cellAlignment: pw.Alignment.centerLeft,
                          headerStyle:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          cellStyle: const pw.TextStyle(fontSize: 12),
                          cellPadding: const pw.EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ));
                  final bytes = await pdf.save();

                  final directory =
                      await FilePicker.platform.getDirectoryPath();
                  if (directory != null) {
                    final file = File(
                        '$directory/Customers_Report_${DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now())}.pdf');
                    await file.writeAsBytes(bytes);
                    showSnackBar(context,
                        'PDF saved successfully at ${file.path}', accentColor);
                  }
                },
                child: const Text('Generate Report'),
              ),
            ),
          )
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

      showSnackBar(context, message, accentColor);

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

void _showDetailsDialog(userModel customer, BuildContext context,
    final VoidCallback onVehicleUpdated) {
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
      text: DateFormat('dd-MM-yyyy').format(customer.birthDate));
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
              vehicles = snapshot.data!
                  .where((vehicle) => vehicle.isArchived == false)
                  .toList();
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
                                '#',
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
                            header: const Center(
                              child: Text(
                                'Customer Vehicles',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            rowsPerPage: 2,
                            source: CustomerVehiclesDataTableSource(vehicles,
                                clientProvider, context, onVehicleUpdated),
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

  final VoidCallback onVehicleUpdated;
  final BuildContext context;

  CustomerVehiclesDataTableSource(
      this._vehicles, this.clientProvider, this.context, this.onVehicleUpdated);

  @override
  DataRow getRow(int index) {
    final VehicleModel vehicle = _vehicles[index];
    var rowNumber = _vehicles.indexOf(
            _vehicles.firstWhere((element) => element.id == vehicle.id)) +
        1;
    return DataRow(
      cells: [
        DataCell(Text(rowNumber.toString())),
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
        builder: (context) => VehicleDetailsScreen(
            vehicle: vehicle, onVehicleUpdated: onVehicleUpdated),
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
  final VoidCallback onVehicleUpdated;

  CustomerDataTableSource(this._customers,
      {required this.refreshData,
      required this.clientProvider,
      required this.context,
      required this.onVehicleUpdated});
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
            _showDetailsDialog(customer, context, onVehicleUpdated);
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
