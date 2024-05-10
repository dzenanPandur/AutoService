import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/providers/VehicleProvider.dart';
import 'package:autoservice_desktop/screens/Employee/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../enum.dart';
import '../../globals.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

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
  @override
  void initState() {
    super.initState();
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
                                  'ID',
                                  style: TextStyle(color: fontColor),
                                )),
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
                              source: VehicleDataTableSource(
                                displayedVehicles,
                                vehicleProvider: vehicleProvider,
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

  void _searchVehicles() {
    String clientNameSearchText = searchByClientName.text.toLowerCase();
    String vehicleNameSearchText = searchByVehicleName.text.toLowerCase();

    if (vehicles != null) {
      filteredVehicles = vehicles!
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

      showSnackBar(context, message);

      _refreshData();
    }
  }

  List<VehicleModel> _getDisplayedVehicles() {
    if (filteredVehicles.isNotEmpty) {
      return filteredVehicles;
    } else {
      return vehicles ?? [];
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

  VehicleDataTableSource(this._vehicles,
      {required this.refreshData,
      required this.vehicleProvider,
      required this.context});

  @override
  DataRow getRow(int index) {
    final VehicleModel vehicle = _vehicles[index];

    return DataRow(
      cells: [
        DataCell(Text(vehicle.id.toString())),
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
