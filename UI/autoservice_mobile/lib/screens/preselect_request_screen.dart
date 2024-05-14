// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/models/appointmentModel.dart';
import 'package:autoservice_mobile/providers/AppointmentProvider.dart';
import 'package:autoservice_mobile/providers/RequestProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../globals.dart';
import '../models/categoryModel.dart';
import '../models/request/createRequestModel.dart';
import '../models/serviceModel.dart';
import '../models/vehicleModel.dart';
import '../providers/CategoryProvider.dart';
import '../providers/ServiceProvider.dart';

class PreselectRequestScreen extends StatefulWidget {
  final List<VehicleModel> vehicles;
  final String userId;
  final List<int> selectedServiceIds;
  const PreselectRequestScreen(
      {Key? key,
      required this.vehicles,
      required this.userId,
      required this.selectedServiceIds})
      : super(key: key);

  @override
  _PreselectRequestScreenState createState() => _PreselectRequestScreenState();
}

class _PreselectRequestScreenState extends State<PreselectRequestScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _customRequestController =
      TextEditingController();
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  final RequestProvider requestProvider = RequestProvider();
  final AppointmentProvider appointmentProvider = AppointmentProvider();
  List<CategoryModel> categories = [];
  List<AppointmentModel> appointments = [];
  List<ServiceModel> services = [];
  late VehicleModel _selectedVehicle;

  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeDataFuture = loadData();
    if (widget.vehicles.isNotEmpty) {
      _selectedVehicle = widget.vehicles.first;
    }
  }

  Future<void> loadData() async {
    categories = await categoryProvider.getAll();
    services = await serviceProvider.getAll();
    appointments = await appointmentProvider.getAll();
    setState(() {});
  }

  double _calculateTotalCost() {
    double totalCost = 0;
    for (var serviceId in widget.selectedServiceIds) {
      final service = services.firstWhere((s) => s.id == serviceId);
      totalCost += service.price;
    }

    double discountedCost = totalCost * 0.85;
    return discountedCost;
  }

  Widget _buildEstimatedCostSection() {
    double estimatedCost = _calculateTotalCost();
    double originalCost = _calculateTotalCost() / 0.85;

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Text(
            'Estimated Cost: ${estimatedCost.toStringAsFixed(2)} KM',
            style: TextStyle(
              fontSize: 20,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Original Cost: ${originalCost.toStringAsFixed(2)} KM',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            'Discount: ${(originalCost - estimatedCost).toStringAsFixed(2)} KM (15%)',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '*Custom request cost not included',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
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
            'Create request',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<void>(
              future: _initializeDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDatePicker(
                          'Date of Service', context, _dateController),
                      const SizedBox(height: 20),
                      Text('Select Vehicle:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      _buildVehicleDropdown(),
                      const SizedBox(height: 20),
                      Text('Services Available:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      _buildServiceSection(),
                      const SizedBox(height: 20),
                      Text('Custom Request:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        maxLength: 100,
                        controller: _customRequestController,
                      ),
                      const SizedBox(height: 20),
                      _buildEstimatedCostSection(),
                      const SizedBox(height: 20),
                      Center(
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
                          onPressed: _createRequest,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Create request',
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

  DateTime _findFirstAvailableDate(DateTime currentDate) {
    while (true) {
      bool isOccupied = appointments.any((appointment) =>
          appointment.isOccupied &&
          appointment.date.year == currentDate.year &&
          appointment.date.month == currentDate.month &&
          appointment.date.day == currentDate.day);

      if (!isOccupied) {
        return currentDate;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }
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
              initialDate: _findFirstAvailableDate(
                  DateTime.now().add(const Duration(days: 1))),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime(2100),
              selectableDayPredicate: (DateTime date) {
                if (appointments.isNotEmpty) {
                  for (var appointment in appointments) {
                    if (appointment.isOccupied &&
                        date.day == appointment.date.day &&
                        date.month == appointment.date.month &&
                        date.year == appointment.date.year) {
                      return false;
                    }
                  }
                }

                return true;
              },
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: secondaryColor,
                      onPrimary: fontColor,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: secondaryColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              setState(() {
                dateController.text =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: DropdownButton<VehicleModel>(
          isExpanded: true,
          value: _selectedVehicle,
          onChanged: (newValue) {
            setState(() {
              _selectedVehicle = newValue!;
            });
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          items: widget.vehicles
              .map<DropdownMenuItem<VehicleModel>>((VehicleModel vehicle) {
            return DropdownMenuItem<VehicleModel>(
              value: vehicle,
              child: Text(
                '${vehicle.make} ${vehicle.model}',
                textAlign: TextAlign.left,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    final activeServices =
        services.where((service) => service.isActive).toList();

    final Map<String, List<ServiceModel>> servicesByCategory = {};
    activeServices.forEach((service) {
      if (!servicesByCategory.containsKey(service.categoryName)) {
        servicesByCategory[service.categoryName!] = [];
      }
      servicesByCategory[service.categoryName]!.add(service);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        for (final category in servicesByCategory.keys)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: primaryBackgroundColor),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: servicesByCategory[category]!.length,
                  itemBuilder: (context, index) {
                    final service = servicesByCategory[category]![index];
                    return Row(
                      children: [
                        Checkbox(
                          checkColor: primaryBackgroundColor,
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return secondaryColor;
                              }
                              return null;
                            },
                          ),
                          value: widget.selectedServiceIds.contains(service.id),
                          onChanged: (value) {
                            null;
                          },
                        ),
                        Expanded(
                          child: Text(service.name),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _createRequest() async {
    if (_dateController.text.isEmpty) {
      showSnackBar(
        context,
        "Please select a date for the service.",
        secondaryColor,
      );
      return;
    }

    DateTime appointmentDate;
    try {
      appointmentDate = DateFormat('dd-MM-yyyy').parse(_dateController.text);
    } catch (e) {
      showSnackBar(context, "Invalid date format", secondaryColor);
      return;
    }

    final request = CreateRequestModel(
      id: 0,
      status: 1,
      dateRequested: DateTime.now(),
      dateCompleted: DateTime.now(),
      totalCost: _calculateTotalCost(),
      customRequest: _customRequestController.text,
      message: '',
      appointment: AppointmentModel(
        id: 0,
        isOccupied: true,
        date: appointmentDate,
      ),
      clientId: widget.userId,
      vehicleId: _selectedVehicle.id,
      serviceIdList: widget.selectedServiceIds,
    );

    try {
      await requestProvider.create(request);
      showSnackBar(context, "Successfully created request", null);
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, "Failed creating request: $e", secondaryColor);
    }
  }
}
