// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/globals.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';
import 'package:autoservice_mobile/screens/add_maintanence_record_screen.dart';
import '../models/vehicleServiceRecordModel.dart';
import '../../providers/vehicleServiceRecordProvider.dart';
import 'maintenance_details_screen.dart';

class PastMaintenanceRecordScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const PastMaintenanceRecordScreen({Key? key, required this.vehicle})
      : super(key: key);

  @override
  _PastMaintenanceRecordScreenState createState() =>
      _PastMaintenanceRecordScreenState();
}

class _PastMaintenanceRecordScreenState
    extends State<PastMaintenanceRecordScreen> {
  late Future<List<VehicleServiceRecordModel>> _recordFuture;

  @override
  void initState() {
    super.initState();
    _recordFuture = VehicleServiceRecordProvider()
        .getAllRecordsByVehicle(widget.vehicle.id);
  }

  Future<void> _fetchRecords() async {
    try {
      _recordFuture = VehicleServiceRecordProvider()
          .getAllRecordsByVehicle(widget.vehicle.id);
    } catch (e) {
      showSnackBar(context, 'Error fetching record: $e', secondaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
        title: const Text(
          'Past Maintenance Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<VehicleServiceRecordModel>>(
        future: _recordFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No maintenance records found'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMaintenanceRecordScreen(
                              vehicle: widget.vehicle),
                        ),
                      ).then((_) => setState(() {
                            _fetchRecords();
                          }));
                    },
                    child: const Text('Add New Record'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                              label: Text('Date',
                                  style: TextStyle(color: secondaryColor))),
                          DataColumn(
                              label: Text('Mileage',
                                  style: TextStyle(color: secondaryColor))),
                          DataColumn(
                              label: Text('Delete',
                                  style: TextStyle(color: secondaryColor))),
                        ],
                        rows: snapshot.data!.map((record) {
                          return DataRow(
                            onSelectChanged: (_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MaintenanceRecordDetailsScreen(
                                            record: record)),
                              ).then((_) => setState(() {
                                    _fetchRecords();
                                  }));
                            },
                            cells: [
                              DataCell(Text(_formatDate(record.date))),
                              DataCell(Text(
                                  record.mileageAtTimeOfService.toString())),
                              DataCell(
                                IconButton(
                                  icon:
                                      Icon(Icons.delete, color: secondaryColor),
                                  onPressed: () async {
                                    bool deleteConfirmed = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        elevation: 0,
                                        backgroundColor: primaryBackgroundColor,
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this record?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    color: secondaryColor)),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: secondaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (deleteConfirmed == true) {
                                      await _deleteRecord(record.id);
                                      setState(() {
                                        _recordFuture =
                                            VehicleServiceRecordProvider()
                                                .getAllRecordsByVehicle(
                                                    widget.vehicle.id);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMaintenanceRecordScreen(
                              vehicle: widget.vehicle),
                        ),
                      ).then((value) => setState(() {
                            _fetchRecords();
                          }));
                    },
                    child: const Text('Add New Record'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> _deleteRecord(int recordId) async {
    try {
      await VehicleServiceRecordProvider().delete(recordId);
    } catch (e) {
      showSnackBar(context, 'Error deleting record: $e', secondaryColor);
    }
  }
}
