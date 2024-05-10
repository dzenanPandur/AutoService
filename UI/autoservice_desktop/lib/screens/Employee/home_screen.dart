import 'package:autoservice_desktop/screens/Employee/customers_screen.dart';
import 'package:autoservice_desktop/screens/Employee/requests_screen.dart';
import 'package:autoservice_desktop/screens/Employee/services_screen.dart';
import 'package:autoservice_desktop/screens/Employee/vehicles_screen.dart';
import 'package:autoservice_desktop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../models/storageService.dart';
import '../../providers/AuthProvider.dart';
import 'sidebar_employee.dart';

class HomeEmployeeScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final StorageService? storageService;

  const HomeEmployeeScreen(
      {Key? key, required this.authProvider, required this.storageService})
      : super(key: key);

  @override
  State<HomeEmployeeScreen> createState() => _HomeEmployeeScreenState();
}

class _HomeEmployeeScreenState extends State<HomeEmployeeScreen> {
  int _selectedIndex = 0;
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const RequestsScreen();
      case 1:
        return const ServiceScreen();
      case 2:
        return const VehiclesScreen();
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
      body: Row(
        children: [
          Sidebar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedIndex: _selectedIndex,
            authProvider: widget.authProvider,
            storageService: widget.storageService,
          ),
          Expanded(
            child: _getScreen(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
