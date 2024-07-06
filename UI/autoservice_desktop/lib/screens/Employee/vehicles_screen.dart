// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/providers/VehicleProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../enum.dart';
import '../../globals.dart';
import '../../models/Employee/requestModel.dart';
import '../../providers/RequestProvider.dart';

class VehiclesScreen extends StatefulWidget {
  final Function(VehicleModel) onVehicleSelected;
  const VehiclesScreen({super.key, required this.onVehicleSelected});

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final VehicleProvider vehicleProvider = VehicleProvider();
  List<VehicleModel>? vehicles;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController searchByClientName = TextEditingController();
  TextEditingController searchByVehicleName = TextEditingController();
  List<Status> selectedStatuses = [];
  List<VehicleModel> filteredVehicles = [];

  List<VehicleModel> _activeVehicles = [];

  Future<void> _fetchVehicles() async {
    vehicles = await vehicleProvider.getAll();
    _activeVehicles =
        vehicles!.where((vehicle) => !vehicle.isArchived!).toList();
    filteredVehicles = _activeVehicles;
    setState(() {});
  }

  void _refreshVehicles() {
    _fetchVehicles();
  }

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Management',
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
                    controller: searchByClientName,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Client Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchByVehicleName,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Vehicle Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MultiSelectDialogField<Status>(
                    checkColor: fontColor,
                    backgroundColor: primaryBackgroundColor,
                    selectedColor: secondaryColor,
                    dialogWidth: MediaQuery.of(context).size.width * 0.3,
                    dialogHeight: MediaQuery.of(context).size.height * 0.7,
                    chipDisplay: MultiSelectChipDisplay.none(),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey,
                      )),
                    ),
                    title: const Text('Select Status'),
                    buttonText: const Text('Select Status'),
                    items: Status.values
                        .map((status) => MultiSelectItem<Status>(
                              status,
                              status.toString().split('.').last,
                            ))
                        .toList(),
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<Status> statuses) {
                      setState(() {
                        selectedStatuses = statuses;
                      });
                    },
                    initialValue: selectedStatuses,
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
                    _searchVehicles();
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
              child: FutureBuilder<List<VehicleModel>>(
                future: vehicleProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    vehicles = snapshot.data;
                    List<VehicleModel> displayedVehicles =
                        _getDisplayedVehicles();
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
                                  'Status',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Owner',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Car',
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
                                  'Vehicles',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              rowsPerPage: 5,
                              source: VehicleDataTableSource(displayedVehicles,
                                  vehicleProvider: vehicleProvider,
                                  context: context,
                                  refreshData: _refreshData,
                                  onVehicleUpdated: _refreshVehicles,
                                  onVehicleSelected: widget.onVehicleSelected),
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

                  List<RequestModel> allRequests =
                      await RequestProvider().getAll();
                  List<VehicleModel> allVehicles =
                      await VehicleProvider().getAll();
                  Map<int, VehicleModel> vehicleLookup = {
                    for (var v in allVehicles) v.id: v
                  };
                  Map<String, Map<String, dynamic>>
                      calculateTopServicedVehicles(
                          List<RequestModel> requests) {
                    Map<String, Map<String, dynamic>> vehicleStats = {};
                    for (var request in requests) {
                      if (request.status != 'Completed') continue;
                      VehicleModel? vehicle = vehicleLookup[request.vehicleId];
                      if (vehicle == null) continue;
                      String vehicleKey = '${vehicle.make} ${vehicle.model}';
                      if (!vehicleStats.containsKey(vehicleKey)) {
                        vehicleStats[vehicleKey] = {
                          'services': 0,
                          'broughtIn': 0
                        };
                      }
                      vehicleStats[vehicleKey]!['services'] +=
                          request.serviceIdList.length;
                      vehicleStats[vehicleKey]!['broughtIn'] += 1;
                    }
                    var sortedVehicles = vehicleStats.entries.toList()
                      ..sort((a, b) =>
                          b.value['services'].compareTo(a.value['services']));
                    return Map.fromEntries(sortedVehicles.take(5));
                  }

                  Map<String, double> calculateTopAverageMaintenanceCost(
                      List<RequestModel> requests) {
                    Map<String, List<double>> vehicleCosts = {};
                    for (var request in requests) {
                      if (request.status != 'Completed') continue;
                      VehicleModel? vehicle = vehicleLookup[request.vehicleId];
                      if (vehicle == null) continue;
                      String vehicleKey = '${vehicle.make} ${vehicle.model}';
                      if (!vehicleCosts.containsKey(vehicleKey)) {
                        vehicleCosts[vehicleKey] = [];
                      }
                      vehicleCosts[vehicleKey]!.add(request.totalCost ?? 0);
                    }
                    Map<String, double> averageCosts = {};
                    vehicleCosts.forEach((key, value) {
                      averageCosts[key] =
                          value.reduce((a, b) => a + b) / value.length;
                    });
                    var sortedCosts = averageCosts.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));
                    return Map.fromEntries(sortedCosts.take(5));
                  }

                  var topServicedVehicles =
                      calculateTopServicedVehicles(allRequests);
                  var topAverageMaintenanceCost =
                      calculateTopAverageMaintenanceCost(allRequests);

                  pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Column(
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
                            'Vehicles report generated at: ${DateFormat('dd.MM.yyyy').format(DateTime.now())} at ${DateFormat('HH:mm').format(DateTime.now())}',
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Text(
                            'Top 5 Most Serviced Vehicles:',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 10),
                          pw.TableHelper.fromTextArray(
                            headers: [
                              'Vehicle',
                              'Services Done',
                              'Times Brought In'
                            ],
                            data: topServicedVehicles.entries
                                .map((entry) => [
                                      entry.key,
                                      entry.value['services'].toString(),
                                      entry.value['broughtIn'].toString(),
                                    ])
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
                            'Top 5 Average Maintenance Cost per Vehicle:',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 10),
                          pw.TableHelper.fromTextArray(
                            headers: ['Vehicle', 'Average Cost'],
                            data: topAverageMaintenanceCost.entries
                                .map((entry) => [
                                      entry.key,
                                      '${entry.value.toStringAsFixed(2)} KM',
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
                      );
                    },
                  ));

                  final bytes = await pdf.save();

                  final directory =
                      await FilePicker.platform.getDirectoryPath();
                  if (directory != null) {
                    final file = File(
                        '$directory/Vehicles_Report_${DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now())}.pdf');
                    await file.writeAsBytes(bytes);
                    showSnackBar(context,
                        'PDF saved successfully at ${file.path}', accentColor);
                  }
                },
                child: const Text('Generate Report'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchVehicles() {
    String clientNameSearchText = searchByClientName.text.toLowerCase();
    String vehicleNameSearchText = searchByVehicleName.text.toLowerCase();

    if (vehicles != null) {
      filteredVehicles = _activeVehicles
          .where((vehicle) =>
              vehicle.clientName.toLowerCase().contains(clientNameSearchText) &&
              '${vehicle.make}' '${vehicle.model}'
                  .toLowerCase()
                  .contains(vehicleNameSearchText) &&
              (selectedStatuses.isEmpty ||
                  selectedStatuses
                      .contains(Status.values[vehicle.statusId - 1])))
          .toList();

      String message;
      if (filteredVehicles.isNotEmpty) {
        message =
            '${filteredVehicles.length} request(s) found for selected filters';
      } else {
        message = 'No requests found for selected filters';
      }

      showSnackBar(context, message, accentColor);

      _refreshData();
    }
  }

  List<VehicleModel> _getDisplayedVehicles() {
    if (filteredVehicles.isNotEmpty) {
      return filteredVehicles;
    } else {
      return _activeVehicles;
    }
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }
}

class VehicleDataTableSource extends DataTableSource {
  final List<VehicleModel> _vehicles;
  final VehicleProvider vehicleProvider;
  final BuildContext context;
  final Function refreshData;
  final VoidCallback onVehicleUpdated;
  final Function(VehicleModel) onVehicleSelected;

  VehicleDataTableSource(this._vehicles,
      {required this.refreshData,
      required this.vehicleProvider,
      required this.context,
      required this.onVehicleSelected,
      required this.onVehicleUpdated});

  @override
  DataRow getRow(int index) {
    final VehicleModel vehicle = _vehicles[index];

    return DataRow(
      cells: [
        DataCell(Text(vehicle.status)),
        DataCell(Text(vehicle.clientName)),
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
            _openDetailsScreen(context, vehicle);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  void _openDetailsScreen(BuildContext context, VehicleModel vehicle) {
    onVehicleSelected(vehicle);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _vehicles.length;

  @override
  int get selectedRowCount => 0;
}
