import 'package:autoservice_mobile/screens/payments_pending_screen.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/providers/AuthProvider.dart';
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';
import 'create_request_screen.dart';
import 'vehicle_details_screen.dart';
import 'add_vehicle_screen.dart';
import 'requests_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _vehicleFuture = _loadVehicles();
  }

  Future<List<VehicleModel>> _loadVehicles() async {
    setState(() {
      _loadingVehicles = true;
    });

    try {
      final vehicles =
          await clientProvider.getAllVehiclesByClient(widget.userId);

      final activeVehicles =
          vehicles.where((vehicle) => !vehicle.isArchived!).toList();

      setState(() {
        _vehicleFuture = Future.value(activeVehicles);
      });

      return activeVehicles;
    } catch (error) {
      print('Error loading vehicles: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(context, 'Major \n service', 180, 120, 35,
                    const CreateRequestScreen()),
                _buildSquareButton(context, 'Basic \n service', 180, 120, 35,
                    const CreateRequestScreen()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(context, 'Custom \n service', 120, 100, 15,
                    const CreateRequestScreen()),
                _buildSquareButton(context, 'My \n services', 120, 100, 15,
                    RequestsScreen(userId: widget.userId)),
                _buildSquareButton(context, 'Pending \n payments', 120, 100, 15,
                    PaymentsPendingScreen(userId: widget.userId)),
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
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddVehicleScreen(onVehicleAdded: _loadVehicles),
                  ),
                ).then((_) => _loadVehicles());
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
      double height, double fontSize, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
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
