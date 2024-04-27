import 'package:autoservice_mobile/screens/add_vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/providers/AuthProvider.dart';
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/models/vehicleModel.dart';

import '../globals.dart';
import 'vehicle_details_screen.dart';

AuthProvider authProvider = AuthProvider();
ClientProvider clientProvider = ClientProvider();

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<VehicleModel> vehicles;

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    setState(() {
      vehicles = [];
    });

    try {
      List<VehicleModel> fetchedVehicles =
          await clientProvider.getAllVehiclesByClient(widget.userId);
      setState(() {
        vehicles = fetchedVehicles;
      });
    } catch (error) {
      print('Error loading vehicles: $error');
    }
  }

  void _handleVehiclesChange() {
    loadVehicles();
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
      body: Column(
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
              _buildSquareButton(context, 'Major \n service', 180, 120, 35),
              _buildSquareButton(context, 'Basic \n service', 180, 120, 35),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSquareButton(context, 'Custom \n service', 120, 100, 15),
              _buildSquareButton(context, 'My \n services', 120, 100, 15),
              _buildSquareButton(context, 'Pending \n payments', 120, 100, 15),
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
          Expanded(
            child: SingleChildScrollView(
              child: vehicles != []
                  ? DataTable(
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text('Vehicle Name')),
                        DataColumn(label: Text('Mileage')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: vehicles.map((vehicle) {
                        return DataRow(
                          onSelectChanged: (_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleDetailsScreen(
                                    vehicle: vehicle,
                                    onVehicleUpdated: _handleVehiclesChange),
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text('${vehicle.make} ${vehicle.model}')),
                            DataCell(Text(vehicle.mileage.toString())),
                            DataCell(Text(vehicle.status!)),
                          ],
                        );
                      }).toList(),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddVehicleScreen(onVehicleAdded: _handleVehiclesChange),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String label, double width,
      double height, double fontSize) {
    return ElevatedButton(
      onPressed: () {},
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
              fontSize: fontSize, color: Color.fromARGB(255, 90, 89, 87)
              //fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
