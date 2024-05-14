import 'package:autoservice_desktop/models/Employee/requestModel.dart';
import 'package:autoservice_desktop/screens/Employee/customers_screen.dart';
import 'package:autoservice_desktop/screens/Employee/request_details_screen.dart';
import 'package:autoservice_desktop/screens/Employee/requests_screen.dart';
import 'package:autoservice_desktop/screens/Employee/services_screen.dart';
import 'package:autoservice_desktop/screens/Employee/vehicles_screen.dart';
import 'package:autoservice_desktop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../models/Employee/vehicleModel.dart';
import '../../models/storageService.dart';
import '../../providers/AuthProvider.dart';
import 'sidebar_employee.dart';
import 'vehicle_details_screen.dart';

class HomeEmployeeScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final StorageService? storageService;

  const HomeEmployeeScreen({
    Key? key,
    required this.authProvider,
    required this.storageService,
  }) : super(key: key);

  @override
  State<HomeEmployeeScreen> createState() => _HomeEmployeeScreenState();
}

class _HomeEmployeeScreenState extends State<HomeEmployeeScreen> {
  RequestModel? _selectedRequest;
  VehicleModel? _selectedVehicle;

  int _selectedIndex = 0;
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return RequestsScreen(
          onRequestSelected: (request) {
            setState(() {
              _selectedRequest = request;
              _selectedVehicle = null;
            });
          },
        );
      case 1:
        return const ServiceScreen();
      case 2:
        return VehiclesScreen(
          onVehicleSelected: (vehicle) {
            setState(() {
              _selectedVehicle = vehicle;
            });
          },
        );
      case 3:
        return const CustomersScreen();
      case 4:
        return ProfileScreen(
          storageService: widget.storageService,
        );
      default:
        return const Center(child: Text('Screen not implemented'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Sidebar(
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _selectedRequest = null;
                    _selectedVehicle = null;
                  });
                },
                selectedIndex: _selectedIndex,
                authProvider: widget.authProvider,
                storageService: widget.storageService,
              ),
              Expanded(
                child: _selectedVehicle != null
                    ? VehicleDetailsScreen(
                        vehicle: _selectedVehicle!,
                        onVehicleUpdated: () {
                          setState(() {
                            _selectedVehicle = null;
                          });
                        },
                      )
                    : _selectedRequest != null
                        ? RequestDetailsScreen(
                            request: _selectedRequest!,
                            onRequestUpdated: () {
                              setState(() {
                                _selectedRequest = null;
                              });
                            },
                          )
                        : _getScreen(_selectedIndex),
              ),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: 250,
            ),
          ),
        ],
      ),
    );
  }
}
