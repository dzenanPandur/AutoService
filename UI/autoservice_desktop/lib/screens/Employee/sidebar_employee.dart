import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../../models/storageService.dart';
import '../../providers/AuthProvider.dart';

class Sidebar extends StatelessWidget {
  final StorageService? storageService;
  final int selectedIndex;
  final Function(int) onTap;
  final AuthProvider authProvider;

  const Sidebar({
    super.key,
    required this.onTap,
    required this.selectedIndex,
    required this.authProvider,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    String userName = storageService!.username;

    return SizedBox(
      width: 250,
      child: Ink(
        color: accentColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("AutoService",
                            style: TextStyle(color: fontColor, fontSize: 30)),
                        Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: Text("employee",
                              style: TextStyle(
                                  color: fontColor,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic)),
                        ),
                        const SizedBox(height: 15),
                        Text("Welcome $userName",
                            style: TextStyle(color: fontColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  _createDrawerItem(
                      icon: Icons.input, text: 'Requests', index: 0),
                  Divider(
                    color: primaryBackgroundColor,
                    indent: 50,
                    endIndent: 50,
                  ),
                  _createDrawerItem(
                      icon: Icons.build, text: 'Services', index: 1),
                  Divider(
                    color: primaryBackgroundColor,
                    indent: 50,
                    endIndent: 50,
                  ),
                  _createDrawerItem(
                      icon: Icons.directions_car, text: 'Vehicles', index: 2),
                  Divider(
                    color: primaryBackgroundColor,
                    indent: 50,
                    endIndent: 50,
                  ),
                  _createDrawerItem(
                      icon: Icons.group, text: 'Customers', index: 3),
                  Divider(
                    color: primaryBackgroundColor,
                    indent: 50,
                    endIndent: 50,
                  ),
                  _createDrawerItem(
                      icon: Icons.account_circle, text: 'Profile', index: 4),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: fontColor,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: fontColor),
              ),
              onTap: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen(authProvider: authProvider)));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    return ListTile(
      selectedColor: fontColor,
      selectedTileColor: secondaryColor,
      leading: Icon(icon, color: fontColor),
      title: Text(
        text,
        style: TextStyle(color: fontColor),
      ),
      selected: index == selectedIndex,
      onTap: () => onTap(index),
    );
  }
}
