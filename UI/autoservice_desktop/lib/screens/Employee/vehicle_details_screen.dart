import 'package:autoservice_desktop/providers/ServiceProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../globals.dart';
import '../../models/Employee/serviceModel.dart';
import '../../models/Employee/vehicleModel.dart';
import '../../models/Employee/vehicleServiceRecordModel.dart';
import '../../providers/VehicleServiceRecordProvider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final VehicleModel vehicle;

  final VoidCallback onVehicleUpdated;
  const VehicleDetailsScreen(
      {Key? key, required this.vehicle, required this.onVehicleUpdated})
      : super(key: key);

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final VehicleServiceRecordProvider serviceRecordProvider =
      VehicleServiceRecordProvider();
  ServiceProvider serviceProvider = ServiceProvider();
  List<VehicleServiceRecordModel>? serviceRecords;

  @override
  void initState() {
    super.initState();
    fetchServiceRecords();
  }

  Future<List<VehicleServiceRecordModel>> fetchServiceRecords() async {
    try {
      return await serviceRecordProvider
          .getAllRecordsByVehicle(widget.vehicle.id);
    } catch (error) {
      print('Error loading service records: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                widget.onVehicleUpdated();
              }
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 35,
            ),
          ),
          title: const Text(
            'Vehicle Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: secondaryColor,
          foregroundColor: fontColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<VehicleServiceRecordModel>>(
                future: fetchServiceRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<VehicleServiceRecordModel> serviceRecords =
                        snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopDetailsRow(),
                        const SizedBox(height: 16.0),
                        _buildMiddleDetailsRow(),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Past Maintenance Records',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        _buildMaintenanceRecordsTable(serviceRecords),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  }
                }),
          ),
        ));
  }

  Widget _buildTopDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextField('Make', widget.vehicle.make, true),
        _buildTextField('Model', widget.vehicle.model, true),
        _buildTextField('Fuel Type', widget.vehicle.vehicleFuelTypeName, true),
        _buildTextField('Vehicle Type', widget.vehicle.vehicleTypeName, true),
        _buildTextField(
          'Transmission Type',
          widget.vehicle.transmissionTypeName,
          true,
        ),
      ],
    );
  }

  Widget _buildMiddleDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextField('VIN', widget.vehicle.vin, true),
        _buildTextField(
          'Manufacture Year',
          widget.vehicle.manufactureYear.toString(),
          true,
        ),
        _buildTextField('Mileage', widget.vehicle.mileage.toString(), true),
        _buildTextField('Vehicle Status', widget.vehicle.status, true),
      ],
    );
  }

  Widget _buildTextField(String label, String value, bool editable) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Container(
          color: Colors.white,
          child: TextField(
            readOnly: editable,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor)),
              labelText: label,
              labelStyle: TextStyle(color: secondaryColor),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceRecordsTable(
      List<VehicleServiceRecordModel> serviceRecords) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: serviceRecords.isEmpty
          ? const Center(child: Text('No maintenance records available'))
          : PaginatedDataTable(
              headingRowColor: MaterialStateProperty.all(secondaryColor),
              arrowHeadColor: secondaryColor,
              columns: [
                DataColumn(
                    label: Text(
                  'Id',
                  style: TextStyle(color: fontColor),
                )),
                DataColumn(
                    label: Text(
                  'Date',
                  style: TextStyle(color: fontColor),
                )),
                DataColumn(
                    label: Text(
                  'Mileage',
                  style: TextStyle(color: fontColor),
                )),
                DataColumn(
                    label: Text(
                  'Details',
                  style: TextStyle(color: fontColor),
                )),
              ],
              source: MaintenanceRecordsDataTableSource(
                  serviceRecords, context, serviceProvider),
              rowsPerPage: 5,
            ),
    );
  }
}

class MaintenanceRecordsDataTableSource extends DataTableSource {
  final BuildContext context;
  final List<VehicleServiceRecordModel> _serviceRecords;
  final ServiceProvider serviceProvider;

  MaintenanceRecordsDataTableSource(
      this._serviceRecords, this.context, this.serviceProvider);

  @override
  DataRow getRow(int index) {
    if (index >= _serviceRecords.length) {
      return const DataRow(cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text(''))
      ]);
    }
    final VehicleServiceRecordModel record = _serviceRecords[index];

    return DataRow(
      cells: [
        DataCell(Text(record.id.toString())),
        DataCell(Text(DateFormat('dd-MM-yyyy').format(record.date))),
        DataCell(Text(record.mileageAtTimeOfService.toString())),
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
            _openDetailsDialog(context, record);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  void _openDetailsDialog(
      BuildContext context, VehicleServiceRecordModel record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: primaryBackgroundColor,
              title: const Text('Maintenance Record Details'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Date of Service',
                        DateFormat('dd-MM-yyyy').format(record.date), true),
                    _buildTextField('Mileage at Time of Service',
                        record.mileageAtTimeOfService.toString(), true),
                    _buildServiceSection(record.serviceIdList),
                    _buildTextField('Cost', record.cost.toString(), true),
                    _buildTextField('Notes', record.notes, true)
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, String value, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: editable,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: accentColor)),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildServiceSection(List<int> serviceIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<ServiceModel?>>(
          future: _loadSelectedServices(serviceIds),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<ServiceModel?> selectedServices = snapshot.data!;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var service in selectedServices)
                      Row(
                        children: [
                          Checkbox(
                            checkColor: primaryBackgroundColor,
                            fillColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return secondaryColor;
                              }
                              return null;
                            }),
                            value: true,
                            onChanged: null,
                          ),
                          Text(service!.name),
                        ],
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ],
    );
  }

  Future<List<ServiceModel?>> _loadSelectedServices(
      List<int> serviceIds) async {
    List<ServiceModel?> selectedServices = [];

    for (var serviceId in serviceIds) {
      try {
        ServiceModel? service = await serviceProvider.getById(serviceId);
        selectedServices.add(service);
      } catch (error) {
        print('Error loading service: $error');
      }
    }

    return selectedServices;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _serviceRecords.length;

  @override
  int get selectedRowCount => 0;
}
