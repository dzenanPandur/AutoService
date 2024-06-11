import 'package:autoservice_desktop/models/storageService.dart';
import 'package:autoservice_desktop/screens/Admin/employee_screen.dart';
import 'package:autoservice_desktop/screens/Admin/vehicle_data_screen.dart';
import 'package:autoservice_desktop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../providers/AuthProvider.dart';
import 'sidebar_admin.dart';

class HomeAdminScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final StorageService? storageService;

  const HomeAdminScreen(
      {Key? key, required this.authProvider, required this.storageService})
      : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const EmployeeScreen();
      case 1:
        return VehicleDataScreen();
      case 2:
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
