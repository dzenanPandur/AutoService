// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/screens/past_maintenance_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';
import 'package:autoservice_mobile/providers/fuelTypeProvider.dart';
import 'package:autoservice_mobile/providers/transmissionTypeProvider.dart';
import 'package:autoservice_mobile/providers/vehicleTypeProvider.dart';

import '../models/fuelTypeModel.dart';
import '../models/transmissionTypeModel.dart';
import '../models/vehicleTypeModel.dart';
import '../providers/VehicleProvider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final VehicleModel vehicle;
  final Function() onVehicleUpdated;

  const VehicleDetailsScreen(
      {Key? key, required this.vehicle, required this.onVehicleUpdated})
      : super(key: key);

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _manufactureYearController =
      TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  List<String> _fuelTypes = [];
  List<String> _transmissionTypes = [];
  List<String> _carTypes = [];

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

      _makeController.text = widget.vehicle.make;
      _modelController.text = widget.vehicle.model;
      _vinController.text = widget.vehicle.vin;
      _manufactureYearController.text =
          widget.vehicle.manufactureYear.toString();
      _mileageController.text = widget.vehicle.mileage.toString();
    } catch (error) {
      showSnackBar(context, 'Error fetching data: $error', secondaryColor);
    }
  }

  Future<void> _updateVehicle() async {
    VehicleModel updatedVehicle = VehicleModel(
      id: widget.vehicle.id,
      make: _makeController.text,
      model: _modelController.text,
      vin: _vinController.text,
      manufactureYear: int.parse(_manufactureYearController.text),
      mileage: int.parse(_mileageController.text),
      status: widget.vehicle.statusId,
      fuelTypeId: widget.vehicle.fuelTypeId,
      transmissionTypeId: widget.vehicle.transmissionTypeId,
      vehicleTypeId: widget.vehicle.vehicleTypeId,
      isArchived: false,
    );

    try {
      await VehicleProvider().update(updatedVehicle);

      widget.onVehicleUpdated();

      showSnackBar(context, 'Vehicle updated successfully', null);
    } catch (error) {
      showSnackBar(context, 'Failed to update vehicle: $error', secondaryColor);
    }
  }

  Future<void> _deleteVehicle() async {
    try {
      await VehicleProvider().delete(widget.vehicle.id);

      widget.onVehicleUpdated();

      showSnackBar(context, 'Vehicle deleted successfully', null);
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context, 'Failed to delete vehicle: $error', secondaryColor);
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
            'Vehicle details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: fontColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 0,
                      backgroundColor: primaryBackgroundColor,
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this vehicle?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteVehicle();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
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
                        const SizedBox(height: 10),
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
                                    value: widget.vehicle.vehicleFuelTypeName,
                                    onChanged: (newValue) {
                                      int fuelTypeId = _fuelTypes.indexWhere(
                                              (type) => type == newValue) +
                                          1;
                                      setState(() {
                                        widget.vehicle.fuelTypeId = fuelTypeId;
                                        widget.vehicle.vehicleFuelTypeName =
                                            newValue!;
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
                                    value: widget.vehicle.transmissionTypeName,
                                    onChanged: (newValue) {
                                      int transmissionTypeId =
                                          _transmissionTypes.indexWhere(
                                                  (type) => type == newValue) +
                                              1;
                                      setState(() {
                                        widget.vehicle.transmissionTypeId =
                                            transmissionTypeId;
                                        widget.vehicle.transmissionTypeName =
                                            newValue!;
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
                                  Text('Vehicle Status:',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: widget.vehicle.status,
                                    enabled: false,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Vehicle Type:',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold)),
                                  DropdownButton<String>(
                                    value: widget.vehicle.vehicleTypeName,
                                    onChanged: (newValue) {
                                      int vehicleTypeId = _carTypes.indexWhere(
                                              (type) => type == newValue) +
                                          1;
                                      setState(() {
                                        widget.vehicle.vehicleTypeId =
                                            vehicleTypeId;
                                        widget.vehicle.vehicleTypeName =
                                            newValue!;
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
                              backgroundColor: primaryBackgroundColor,
                              foregroundColor: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PastMaintenanceRecordScreen(
                                            vehicle: widget.vehicle),
                                  ));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 60, right: 60),
                              child: Text('Past Maintenance Records'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _updateVehicle,
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
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
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
