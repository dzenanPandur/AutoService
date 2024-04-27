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
      print('Error fetching data: $error');
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
    );

    try {
      await VehicleProvider().update(updatedVehicle);

      widget.onVehicleUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle updated successfully'),
        ),
      );
      //Navigator.pop(context);
    } catch (error) {
      print('Error updating vehicle: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update vehicle: $error'),
        ),
      );
    }
  }

  Future<void> _deleteVehicle() async {
    try {
      await VehicleProvider().delete(widget.vehicle.id);

      widget.onVehicleUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle deleted successfully'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      print('Error deleting vehicle: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete vehicle: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle details'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this vehicle?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteVehicle();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Delete"),
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
                        const Text('Make:'),
                        TextFormField(
                          controller: _makeController,
                        ),
                        const SizedBox(height: 20),
                        const Text('Model:'),
                        TextFormField(
                          controller: _modelController,
                        ),
                        const SizedBox(height: 20),
                        const Text('VIN (Vehicle Identification Number):'),
                        TextFormField(
                          controller: _vinController,
                        ),
                        const SizedBox(height: 20),
                        const Text('Year of Manufacture:'),
                        TextFormField(
                          controller: _manufactureYearController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        const Text('Mileage (in kilometers):'),
                        TextFormField(
                          controller: _mileageController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Fuel Type:'),
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
                                  const Text('Transmission Type:'),
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
                                  const Text('Vehicle Status:'),
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
                                  const Text('Vehicle Type:'),
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
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PastMaintenanceRecordScreen(
                                            vehicle: widget.vehicle),
                                  ));
                            },
                            style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.black),
                            ),
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
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.red,
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
