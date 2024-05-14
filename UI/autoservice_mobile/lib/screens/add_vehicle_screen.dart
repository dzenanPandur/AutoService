// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';
import 'package:autoservice_mobile/providers/fuelTypeProvider.dart';
import 'package:autoservice_mobile/providers/transmissionTypeProvider.dart';
import 'package:autoservice_mobile/providers/vehicleTypeProvider.dart';

import '../globals.dart';
import '../models/fuelTypeModel.dart';
import '../models/transmissionTypeModel.dart';
import '../models/vehicleTypeModel.dart';
import '../providers/VehicleProvider.dart';

class AddVehicleScreen extends StatefulWidget {
  final Function() onVehicleAdded;

  const AddVehicleScreen({Key? key, required this.onVehicleAdded})
      : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _manufactureYearController =
      TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  List<String> _fuelTypes = [];
  List<String> _transmissionTypes = [];
  List<String> _carTypes = [];

  String? _selectedFuelType;
  String? _selectedTransmissionType;
  String? _selectedCarType;

  final FuelTypeProvider _fuelTypeProvider = FuelTypeProvider();
  final TransmissionTypeProvider _transmissionTypeProvider =
      TransmissionTypeProvider();
  final VehicleTypeProvider _vehicleTypeProvider = VehicleTypeProvider();
  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeDataFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      List<FuelTypeModel> fuelTypes = await _fuelTypeProvider.getAll();
      setState(() {
        _fuelTypes = fuelTypes.map((type) => type.name).toList();
      });

      List<TransmissionTypeModel> transmissionTypes =
          await _transmissionTypeProvider.getAll();
      setState(() {
        _transmissionTypes =
            transmissionTypes.map((type) => type.name).toList();
      });

      List<VehicleTypeModel> vehicleTypes = await _vehicleTypeProvider.getAll();
      setState(() {
        _carTypes = vehicleTypes.map((type) => type.name).toList();
      });
    } catch (error) {
      showSnackBar(context, 'Error fetching data: $error', secondaryColor);
    }
  }

  Future<void> _addVehicle() async {
    if (_makeController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _vinController.text.isEmpty ||
        _manufactureYearController.text.isEmpty ||
        _mileageController.text.isEmpty ||
        _selectedFuelType == null ||
        _selectedTransmissionType == null ||
        _selectedCarType == null) {
      showSnackBar(context, 'Please fill in all fields', secondaryColor);
      return;
    }

    VehicleModel newVehicle = VehicleModel(
      id: 0,
      make: _makeController.text,
      model: _modelController.text,
      vin: _vinController.text,
      manufactureYear: int.parse(_manufactureYearController.text),
      mileage: int.parse(_mileageController.text),
      status: 9,
      fuelTypeId: _fuelTypes.indexOf(_selectedFuelType!) + 1,
      transmissionTypeId:
          _transmissionTypes.indexOf(_selectedTransmissionType!) + 1,
      vehicleTypeId: _carTypes.indexOf(_selectedCarType!) + 1,
      isArchived: false,
    );

    try {
      await VehicleProvider().create(newVehicle);

      showSnackBar(context, 'Vehicle added successfully', null);
      widget.onVehicleAdded();
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context, 'Failed to add vehicle: $error', secondaryColor);
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
            'Add new vehicle',
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
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Make:',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 15,
                          controller: _makeController,
                        ),
                        Text('Model:',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 15,
                          controller: _modelController,
                        ),
                        Text('VIN (Vehicle Identification Number):',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 20,
                          controller: _vinController,
                        ),
                        Text('Year of Manufacture:',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 4,
                          controller: _manufactureYearController,
                          keyboardType: TextInputType.number,
                        ),
                        Text('Mileage (in kilometers):',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 7,
                          controller: _mileageController,
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fuel Type:',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold)),
                                  DropdownButton<String>(
                                    value: _selectedFuelType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedFuelType = newValue;
                                      });
                                    },
                                    items: _fuelTypes.map((fuelType) {
                                      return DropdownMenuItem<String>(
                                        value: fuelType,
                                        child: Text(fuelType),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transmission Type:',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold)),
                                  DropdownButton<String>(
                                    value: _selectedTransmissionType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedTransmissionType = newValue;
                                      });
                                    },
                                    items: _transmissionTypes
                                        .map((transmissionType) {
                                      return DropdownMenuItem<String>(
                                        value: transmissionType,
                                        child: Text(transmissionType),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Vehicle Type:',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold)),
                                  DropdownButton<String>(
                                    value: _selectedCarType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCarType = newValue;
                                      });
                                    },
                                    items: _carTypes.map((carType) {
                                      return DropdownMenuItem<String>(
                                        value: carType,
                                        child: Text(carType),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                            onPressed: _addVehicle,
                            child: const Text('Add new vehicle'),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ));
  }
}
