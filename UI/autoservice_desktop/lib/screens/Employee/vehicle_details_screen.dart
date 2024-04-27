import 'package:autoservice_desktop/providers/ServiceProvider.dart';
import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../models/Employee/serviceModel.dart';
import '../../models/Employee/vehicleModel.dart';
import '../../models/Employee/vehicleServiceRecordModel.dart';
import '../../providers/VehicleServiceRecordProvider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailsScreen({Key? key, required this.vehicle})
      : super(key: key);

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final VehicleServiceRecordProvider serviceRecordProvider =
      VehicleServiceRecordProvider(); // Create an instance of the service record provider
  ServiceProvider serviceProvider = ServiceProvider();
  List<VehicleServiceRecordModel>? serviceRecords;

  @override
  void initState() {
    super.initState();
    loadServiceRecords();
  }

  Future<void> loadServiceRecords() async {
    try {
      serviceRecords =
          await serviceRecordProvider.getAllRecordsByVehicle(widget.vehicle.id);
      setState(() {});
    } catch (error) {
      print('Error loading service records: $error');
      // Handle error loading service records
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            _buildMaintenanceRecordsTable(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextField('Make', widget.vehicle.make, true),
        _buildTextField('Model', widget.vehicle.model, true),
        _buildTextField('Fuel Type', widget.vehicle.vehicleFuelTypeName, true),
        _buildTextField('Car Type', widget.vehicle.vehicleTypeName, true),
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
        _buildTextField('Car Status', widget.vehicle.status, true),
      ],
    );
  }

  Widget _buildTextField(String label, String value, bool editable) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: TextField(
          readOnly: editable,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceRecordsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Mileage')),
          DataColumn(label: Text('Details')),
        ],
        source: MaintenanceRecordsDataTableSource(
            serviceRecords ?? [], context, serviceProvider),
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
    final VehicleServiceRecordModel record = _serviceRecords[index];

    return DataRow(
      cells: [
        DataCell(Text(record.id.toString())),
        DataCell(Text(record.date.toString())),
        DataCell(Text(record.mileageAtTimeOfService.toString())),
        DataCell(ElevatedButton(
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
        return AlertDialog(
          title: const Text('Maintenance Record Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Date of Service', record.date.toString(), true),
              _buildTextField('Mileage at Time of Service',
                  record.mileageAtTimeOfService.toString(), true),
              _buildServiceSection(record.serviceIdList),
              //_buildDetailRow('Other Services', record. ?? '', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
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
                  border: Border.all(color: primaryBackgroundColor),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var service in selectedServices)
                      Row(
                        children: [
                          Checkbox(
                            value: true, // Set the value as per your logic
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
        ServiceModel? service = await serviceProvider
            .getById(serviceId); // Replace this with your actual default value
        selectedServices.add(service);
      } catch (error) {
        print('Error loading service: $error');
        // Handle error loading service
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
