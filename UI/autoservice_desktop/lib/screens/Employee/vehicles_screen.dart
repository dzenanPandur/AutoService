import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/providers/VehicleProvider.dart';
import 'package:autoservice_desktop/screens/Employee/vehicle_details_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Management'),
      ),
      body: Column(
        children: [
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

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Owner')),
                              DataColumn(label: Text('Car')),
                              DataColumn(label: Text('Details')),
                            ],
                            header: const Center(
                              child: Text('Vehicles'),
                            ),
                            rowsPerPage: 5,
                            source: VehicleDataTableSource(
                              vehicles!,
                              vehicleProvider: vehicleProvider,
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

class VehicleDataTableSource extends DataTableSource {
  final List<VehicleModel> _vehicles;
  final VehicleProvider vehicleProvider;
  final BuildContext context;
  //final Function(ServiceModel) showDetailsDialog;
  final Function refreshData;

  VehicleDataTableSource(this._vehicles,
      {
      //required this.showDetailsDialog
      required this.refreshData,
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
      FluentPageRoute(
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
