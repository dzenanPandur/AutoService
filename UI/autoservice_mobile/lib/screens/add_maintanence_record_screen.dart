// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/providers/VehicleServiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../globals.dart';
import '../models/categoryModel.dart';
import '../models/serviceModel.dart';
import '../models/vehicleModel.dart';
import '../models/vehicleServiceRecordModel.dart';
import '../providers/CategoryProvider.dart';
import '../providers/ServiceProvider.dart';

class AddMaintenanceRecordScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const AddMaintenanceRecordScreen({Key? key, required this.vehicle})
      : super(key: key);

  @override
  _AddMaintenanceRecordScreenState createState() =>
      _AddMaintenanceRecordScreenState();
}

class _AddMaintenanceRecordScreenState
    extends State<AddMaintenanceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  String? _serviceError;
  String? _dateError;
  String? _mileageError;
  String? _costError;
  final List<GlobalKey<FormFieldState>> _fieldKeys = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  final VehicleServiceRecordProvider recordProvider =
      VehicleServiceRecordProvider();
  List<CategoryModel> categories = [];
  List<ServiceModel> services = [];
  List<int> selectedServiceIds = [];

  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeDataFuture = loadServices();
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

  Future<void> loadServices() async {
    services = await serviceProvider.getAll();
    setState(() {});
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

  String? _validateCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cost cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid cost';
    }
    return null;
  }

  String? _validateMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mileage cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid Mileage';
    }
    return null;
  }

  String? _validateServices() {
    if (selectedServiceIds.isEmpty) {
      return "Please select at least one service.";
    }
    return null;
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
            'Add new record',
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
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Form(
                      key: _formKey,
                      child: Column(
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
                            maxLength: 9,
                            controller: _mileageController,
                            keyboardType: TextInputType.number,
                            key: _addFieldKey(),
                            validator: _validateMileage,
                            decoration:
                                InputDecoration(errorText: _mileageError),
                          ),
                          Text('Services Done:',
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
                          Text('Notes:',
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold)),
                          TextFormField(
                            maxLength: 100,
                            controller: _notesController,
                          ),
                          const SizedBox(height: 20),
                          Text('Cost:',
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold)),
                          TextFormField(
                            maxLength: 15,
                            controller: _costController,
                            validator: _validateCost,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(errorText: _costError),
                            key: _addFieldKey(),
                          ),
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
                              onPressed: _addRecord,
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Add record',
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
                }),
          )),
        ));
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
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              mainAxisSpacing: 0,
              crossAxisSpacing: 8,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
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
        ),
      ],
    );
  }

  void _addRecord() async {
    setState(() {
      _serviceError = _validateServices();
      _dateError = _validateDate(_dateController.text);
      _costError = _validateCost(_costController.text);
      _mileageError = _validateMileage(_mileageController.text);
    });

    if (_formKey.currentState!.validate() &&
        _serviceError == null &&
        _dateError == null &&
        _costError == null &&
        _mileageError == null) {
      try {
        DateTime date = DateFormat('dd-MM-yyyy').parse(_dateController.text);
        int mileage = int.parse(_mileageController.text);
        String notes = _notesController.text;

        VehicleServiceRecordModel newRecord = VehicleServiceRecordModel(
          id: 0,
          date: date,
          mileageAtTimeOfService: mileage,
          cost: double.parse(_costController.text),
          notes: notes,
          vehicleId: widget.vehicle.id,
          serviceIdList: selectedServiceIds,
        );

        await recordProvider.create(newRecord);
        Navigator.pop(context);
        showSnackBar(context, 'Record added successfully.', accentColor);
      } catch (e) {
        showSnackBar(context, 'Error: $e', secondaryColor);
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
