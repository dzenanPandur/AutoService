// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/enum.dart';
import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/models/Employee/updateRequestModel.dart';
import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/providers/VehicleProvider.dart';
import 'package:autoservice_desktop/screens/Employee/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Employee/categoryModel.dart';
import '../../models/Employee/requestModel.dart';
import '../../models/Employee/serviceModel.dart';
import '../../providers/CategoryProvider.dart';
import '../../providers/RequestProvider.dart';
import '../../providers/ServiceProvider.dart';

class RequestDetailsScreen extends StatefulWidget {
  final RequestModel request;

  const RequestDetailsScreen({Key? key, required this.request})
      : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  final VehicleProvider vehicleProvider = VehicleProvider();
  List<CategoryModel> categories = [];
  List<ServiceModel> services = [];
  late int _selectedStatusIndex;
  final List<Status> _statuses = Status.values;
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadServices();
    priceController =
        TextEditingController(text: widget.request.totalCost.toString());
    _selectedStatusIndex = widget.request.statusId - 1;
  }

  Future<void> loadCategories() async {
    categories = await categoryProvider.getAll();
    setState(() {});
  }

  Future<List<ServiceModel>> loadServices() async {
    return await serviceProvider.getAll();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController dateRequestedController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.request.dateRequested));
    TextEditingController customRequestController =
        TextEditingController(text: widget.request.customRequest);
    priceController =
        TextEditingController(text: widget.request.totalCost.toString());
    final List<Status> availableStatuses =
        _getAvailableStatuses(widget.request.status);

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
        title: const Text('Request Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildServiceSection(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'Request Date', dateRequestedController, true),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 30),
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          _openDetailsScreen(context);
                        },
                        child: const Text('Vehicle Details'),
                      ),
                    ],
                  ),
                  _buildTextField(
                      'Custom request', customRequestController, true),
                  _buildTextField('Final price', priceController, false),
                  DropdownButtonFormField<int>(
                    value: _selectedStatusIndex,
                    items: availableStatuses.asMap().entries.map((entry) {
                      final status = entry.value;
                      return DropdownMenuItem<int>(
                        value: _statuses.indexOf(status),
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatusIndex = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: secondaryColor),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Status',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveChanges();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 30),
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text('Save Changes',
                          style: TextStyle(fontSize: 18.0)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetailsScreen(BuildContext context) async {
    try {
      VehicleModel? vehicle =
          await vehicleProvider.getById(widget.request.vehicleId);

      if (vehicle != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(vehicle: vehicle),
          ),
        );
      } else {
        showSnackBar(context, 'Error: Vehicle not found.');
      }
    } catch (error) {
      showSnackBar(context, 'Error loading vehicle details: $error');
    }
  }

  List<Status> _getAvailableStatuses(String currentStatus) {
    Status status = Status.values.firstWhere(
      (e) => e.toString().split('.').last == currentStatus,
      orElse: () => Status.Idle,
    );

    switch (status) {
      case Status.New:
        return [Status.New, Status.Rejected, Status.AwaitingCar];
      case Status.AwaitingCar:
        return [Status.AwaitingCar, Status.Rejected, Status.InService];
      case Status.InService:
        return [Status.InService, Status.PendingPayment];
      case Status.PendingPayment:
        return [Status.PendingPayment, Status.PickupReady];
      case Status.PickupReady:
        return [Status.PickupReady, Status.Completed];
      case Status.Rejected:
      case Status.Completed:
        return [status];
      default:
        return [];
    }
  }

  void _saveChanges() async {
    UpdateRequestModel request = UpdateRequestModel(
      status: _selectedStatusIndex + 1,
      id: widget.request.id,
      totalCost: double.parse(priceController.text),
    );

    try {
      await RequestProvider().updateRequest(request);

      showSnackBar(context, 'Changes saved succesfully');
    } catch (error) {
      showSnackBar(context, 'Failed to save changes. $error');
    }
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: editable,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return FutureBuilder<List<ServiceModel>>(
      future: loadServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<ServiceModel> services = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var category in categories)
                Container(
                  width: double.infinity,
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
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: services
                                .where((s) => s.categoryName == category.name)
                                .map((service) => SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: primaryBackgroundColor,
                                            fillColor: MaterialStateProperty
                                                .resolveWith(
                                              (states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return secondaryColor;
                                                }
                                                return null;
                                              },
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            value: widget.request.serviceIdList
                                                .contains(service.id),
                                            onChanged: null,
                                          ),
                                          Flexible(
                                            child: Text(service.name),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
