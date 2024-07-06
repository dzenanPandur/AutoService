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

class CreateRequestScreen extends StatefulWidget {
  final List<VehicleModel> vehicles;
  final String userId;
  const CreateRequestScreen(
      {Key? key, required this.vehicles, required this.userId})
      : super(key: key);

  @override
  _CreateRequestScreenState createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  String? _serviceError;
  String? _dateError;
  final List<GlobalKey<FormFieldState>> _fieldKeys = [];
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
  List<int> selectedServiceIds = [];
  VehicleModel? _selectedVehicle;

  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeDataFuture = loadData();
    _initializeSelectedVehicle();
  }

  void _initializeSelectedVehicle() {
    List<VehicleModel> idleVehicles =
        widget.vehicles.where((vehicle) => vehicle.status == "Idle").toList();
    if (idleVehicles.isNotEmpty) {
      _selectedVehicle = idleVehicles.first;
    } else {
      _selectedVehicle = null;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey<FormFieldState> _addFieldKey() {
    final key = GlobalKey<FormFieldState>();
    _fieldKeys.add(key);
    return key;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date for the service';
    }
    try {
      DateFormat('dd-MM-yyyy').parse(value);
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  String? _validateServices() {
    if (selectedServiceIds.isEmpty) {
      return "Please select at least one service.";
    }
    return null;
  }

  Future<void> loadData() async {
    categories = await categoryProvider.getAll();
    services = await serviceProvider.getAll();
    appointments = await appointmentProvider.getAll();
    setState(() {});
  }

  double _calculateTotalCost() {
    double totalCost = 0;
    for (var serviceId in selectedServiceIds) {
      final service = services.firstWhere((s) => s.id == serviceId);
      totalCost += service.price;
    }
    return totalCost;
  }

  Widget _buildEstimatedCostSection() {
    double estimatedCost = _calculateTotalCost();
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
    bool areVehiclesAvailable =
        widget.vehicles.any((vehicle) => vehicle.status == "Idle");

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
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<void>(
              future: _initializeDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Form(
                    key: _formKey,
                    child: Column(
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
                        if (_serviceError != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _serviceError!,
                              style: TextStyle(color: secondaryColor),
                            ),
                          ),
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
                        if (!areVehiclesAvailable)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'No vehicles are currently available. You cannot create a request at this time.',
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              backgroundColor: areVehiclesAvailable
                                  ? secondaryColor
                                  : Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed:
                                areVehiclesAvailable ? _createRequest : null,
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
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  DateTime _findFirstAvailableDate(DateTime currentDate) {
    if (appointments.isEmpty) {
      return currentDate;
    }

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
        child: TextFormField(
          controller: dateController,
          readOnly: true,
          validator: _validateDate,
          key: _addFieldKey(),
          decoration: InputDecoration(
            labelText: label,
            errorText: _dateError,
            labelStyle:
                TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              fieldHintText: "dd/mm/yyyy",
              locale: const Locale("en", "GB"),
              initialDate: _findFirstAvailableDate(
                  DateTime.now().add(const Duration(days: 1))),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime(2100),
              selectableDayPredicate: (DateTime date) {
                for (var appointment in appointments) {
                  if (appointment.isOccupied &&
                      date.day == appointment.date.day &&
                      date.month == appointment.date.month &&
                      date.year == appointment.date.year) {
                    return false;
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
    List<VehicleModel> idleVehicles =
        widget.vehicles.where((vehicle) => vehicle.status == "Idle").toList();

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: DropdownButtonFormField<VehicleModel>(
          isExpanded: true,
          value: _selectedVehicle,
          onChanged: idleVehicles.isNotEmpty
              ? (newValue) {
                  setState(() {
                    _selectedVehicle = newValue;
                  });
                }
              : null,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          hint: Text(idleVehicles.isEmpty
              ? "No vehicles currently available"
              : "Select a vehicle"),
          disabledHint: const Text("No vehicles currently available"),
          items: widget.vehicles
              .map<DropdownMenuItem<VehicleModel>>((VehicleModel vehicle) {
            bool isIdle = vehicle.status == "Idle";
            return DropdownMenuItem<VehicleModel>(
              value: vehicle,
              enabled: isIdle,
              child: Text(
                '${vehicle.make} ${vehicle.model}${isIdle ? "" : " (Busy)"}',
                style: TextStyle(
                  color: isIdle ? Colors.black : Colors.grey,
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return widget.vehicles.map<Widget>((VehicleModel vehicle) {
              return Text(
                '${vehicle.make} ${vehicle.model}',
                style: const TextStyle(color: Colors.black),
              );
            }).toList();
          },
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
                          value: selectedServiceIds.contains(service.id),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedServiceIds.add(service.id);
                              } else {
                                selectedServiceIds.remove(service.id);
                              }
                            });
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
    setState(() {
      _serviceError = _validateServices();
      _dateError = _validateDate(_dateController.text);
    });

    if (_formKey.currentState!.validate() &&
        _serviceError == null &&
        _dateError == null) {
      try {
        DateTime appointmentDate;
        try {
          appointmentDate =
              DateFormat('dd-MM-yyyy').parse(_dateController.text);
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
          message: ' ',
          appointment: AppointmentModel(
            id: 0,
            isOccupied: true,
            date: appointmentDate,
          ),
          clientId: widget.userId,
          vehicleId: _selectedVehicle!.id,
          serviceIdList: selectedServiceIds,
        );

        await requestProvider.create(request);
        Navigator.pop(context);
        showSnackBar(context, "Successfully created request", accentColor);
      } catch (e) {
        showSnackBar(context, "Failed creating request: $e", secondaryColor);
      }
    } else {
      _scrollToFirstError();
    }
  }

  void _scrollToFirstError() {
    for (final key in _fieldKeys) {
      if (key.currentState?.hasError ?? false) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.5,
          duration: const Duration(milliseconds: 500),
        );
        break;
      }
    }
  }
}
