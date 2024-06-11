// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/screens/preselect_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/providers/AuthProvider.dart';
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';
import 'package:autoservice_mobile/screens/create_request_screen.dart';
import 'package:autoservice_mobile/screens/vehicle_details_screen.dart';
import 'package:autoservice_mobile/screens/add_vehicle_screen.dart';
import 'package:autoservice_mobile/screens/requests_screen.dart';
import 'package:autoservice_mobile/screens/payments_pending_screen.dart';
import '../globals.dart';

AuthProvider authProvider = AuthProvider();
ClientProvider clientProvider = ClientProvider();

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<VehicleModel>> _vehicleFuture;
  bool _loadingVehicles = false;
  bool _loadingMessages = false;
  List<VehicleModel> _activeVehicles = [];
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _vehicleFuture = _loadVehicles();
  }

  Future<List<VehicleModel>> _loadVehicles() async {
    setState(() {
      _loadingVehicles = true;
    });

    try {
      final vehicles =
          await clientProvider.getAllVehiclesByClient(widget.userId);

      _activeVehicles =
          vehicles.where((vehicle) => !vehicle.isArchived!).toList();

      setState(() {
        _vehicleFuture = Future.value(_activeVehicles);
      });

      return _activeVehicles;
    } catch (error) {
      setState(() {
        _vehicleFuture = Future.value([]);
      });
      return [];
    } finally {
      setState(() {
        _loadingVehicles = false;
      });
    }
  }

  Future<List<String>> _loadMessages() async {
    setState(() {
      _loadingMessages = true;
    });

    try {
      final requests =
          await clientProvider.getAllMessagesByClient(widget.userId);
      List<String> messages = requests
          .where((request) => request.message != Characters.empty.toString())
          .where((request) => request.message != " ")
          .map((request) =>
              'Request for ${request.vehicleName}: ${request.message}')
          .toList();

      setState(() {
        _messages = messages;
      });

      return messages;
    } catch (error) {
      setState(() {
        _messages = [];
      });
      return [];
    } finally {
      setState(() {
        _loadingMessages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: secondaryColor,
        title: Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: const Text('Dashboard'),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authProvider.logout(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 2.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 20),
            _loadingMessages
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _messages.isEmpty
                        ? const Center(child: Text('No messages available.'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Text(
                                  'Messages:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        _messages[index],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(
                    context,
                    'Major \n service',
                    180,
                    120,
                    35,
                    PreselectRequestScreen(
                      vehicles: _activeVehicles,
                      userId: widget.userId,
                      selectedServiceIds: const [1, 2, 3, 4, 5, 6, 7, 8],
                    ),
                    true),
                _buildSquareButton(
                    context,
                    'Basic \n service',
                    180,
                    120,
                    35,
                    PreselectRequestScreen(
                      vehicles: _activeVehicles,
                      userId: widget.userId,
                      selectedServiceIds: const [1, 2, 7, 8],
                    ),
                    true),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(
                    context,
                    'Custom \n service',
                    120,
                    100,
                    15,
                    CreateRequestScreen(
                      vehicles: _activeVehicles,
                      userId: widget.userId,
                    ),
                    true),
                _buildSquareButton(context, 'My \n services', 120, 100, 15,
                    RequestsScreen(userId: widget.userId), false),
                _buildSquareButton(
                    context,
                    'Pending \n payments',
                    120,
                    100,
                    15,
                    PaymentsPendingScreen(
                      userId: widget.userId,
                      onPaymentCompleted: _loadVehicles,
                    ),
                    false),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Your Vehicles',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        height: 2,
                        color: Colors.grey.shade300,
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          width: 130,
                          height: 2,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _loadingVehicles
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<VehicleModel>>(
                    future: _vehicleFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading vehicles: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No vehicles found.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        List<VehicleModel> vehicles = snapshot.data!;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(
                                  label: Text('Vehicle Name',
                                      style: TextStyle(color: secondaryColor))),
                              DataColumn(
                                  label: Text('Mileage',
                                      style: TextStyle(color: secondaryColor))),
                              DataColumn(
                                  label: Text('Status',
                                      style: TextStyle(color: secondaryColor))),
                            ],
                            rows: vehicles.map((vehicle) {
                              return DataRow(
                                onSelectChanged: (_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleDetailsScreen(
                                        vehicle: vehicle,
                                        onVehicleUpdated: _loadVehicles,
                                      ),
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(
                                      Text('${vehicle.make} ${vehicle.model}')),
                                  DataCell(Text(vehicle.mileage.toString())),
                                  DataCell(Text(vehicle.status!)),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              onPressed: () async {
                if (_activeVehicles.length >= 3) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: primaryBackgroundColor,
                        title: const Text('Cannot Add New Vehicle'),
                        content: const Text(
                            'You already have 3 active vehicles. Please delete a vehicle to add a new one.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: secondaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddVehicleScreen(onVehicleAdded: _loadVehicles),
                    ),
                  ).then((_) => _loadVehicles());
                }
              },
              child: const Text('Add New Vehicle'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String label, double width,
      double height, double fontSize, Widget screen, bool value) {
    return ElevatedButton(
      onPressed: () {
        if (value) {
          if (_activeVehicles.isEmpty) {
            showSnackBar(context, "Cannot create request without a vehicle",
                secondaryColor);
          } else if (_activeVehicles.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            ).then((_) => _loadVehicles());
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          ).then((_) => _loadVehicles());
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        backgroundColor: primaryBackgroundColor,
        foregroundColor: Colors.black,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: fontColor),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            color: const Color.fromARGB(255, 90, 89, 87),
          ),
        ),
      ),
    );
  }
}
