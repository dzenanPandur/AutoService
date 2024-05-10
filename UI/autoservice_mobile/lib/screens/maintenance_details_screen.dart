// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/providers/VehicleServiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/models/vehicleServiceRecordModel.dart';
import 'package:intl/intl.dart';

import '../globals.dart';
import '../models/serviceModel.dart';
import '../providers/ServiceProvider.dart';

class MaintenanceRecordDetailsScreen extends StatefulWidget {
  final VehicleServiceRecordModel record;
  const MaintenanceRecordDetailsScreen({Key? key, required this.record})
      : super(key: key);

  @override
  _MaintenanceRecordDetailsScreenState createState() =>
      _MaintenanceRecordDetailsScreenState();
}

class _MaintenanceRecordDetailsScreenState
    extends State<MaintenanceRecordDetailsScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final ServiceProvider serviceProvider = ServiceProvider();
  final VehicleServiceRecordProvider recordProvider =
      VehicleServiceRecordProvider();
  List<ServiceModel> services = [];

  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.record.date);
    _mileageController.text = widget.record.mileageAtTimeOfService.toString();
    _notesController.text = widget.record.notes;
    _initializeDataFuture = loadServices();
  }

  Future<void> loadServices() async {
    services = await serviceProvider.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          foregroundColor: fontColor,
          title: const Text('Maintenance details'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<void>(
              future: _initializeDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDatePicker(
                          'Date of Service', context, _dateController),
                      const SizedBox(height: 20),
                      Text('Mileage at Time of Service (in kilometers):',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        maxLength: 7,
                        controller: _mileageController,
                        keyboardType: TextInputType.number,
                      ),
                      Text('Services Done:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      _buildServiceSection(),
                      const SizedBox(height: 20),
                      Text('Notes:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        maxLength: 100,
                        controller: _notesController,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        )));
  }

  Widget buildDatePicker(String label, BuildContext context,
      TextEditingController dateController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 230,
        child: TextField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                dateController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: primaryBackgroundColor),
            borderRadius: BorderRadius.circular(8.0),
            color: const Color.fromARGB(214, 231, 229, 229),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var service in services)
                Row(
                  children: [
                    Checkbox(
                      value: widget.record.serviceIdList.contains(service.id),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            if (newValue) {
                              widget.record.serviceIdList.add(service.id);
                            } else {
                              widget.record.serviceIdList.remove(service.id);
                            }
                          });
                        }
                      },
                    ),
                    Text(service.name),
                  ],
                ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  void _saveChanges() async {
    try {
      DateTime updatedDate =
          DateFormat('yyyy-MM-dd').parse(_dateController.text);
      int updatedMileage = int.parse(_mileageController.text);
      String updatedNotes = _notesController.text;

      VehicleServiceRecordModel updatedRecord = VehicleServiceRecordModel(
          id: widget.record.id,
          date: updatedDate,
          mileageAtTimeOfService: updatedMileage,
          notes: updatedNotes,
          cost: 0,
          vehicleId: widget.record.vehicleId,
          serviceIdList: widget.record.serviceIdList);

      await recordProvider.update(updatedRecord);

      showSnackBar(context, 'Record updated successfully', null);
    } catch (e) {
      showSnackBar(context, 'Error: $e', secondaryColor);
    }
  }
}
