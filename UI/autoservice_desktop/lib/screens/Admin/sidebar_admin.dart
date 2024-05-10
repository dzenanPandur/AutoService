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

  const Sidebar(
      {super.key,
      required this.onTap,
      required this.selectedIndex,
      required this.authProvider,
      required this.storageService});

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
                          padding: const EdgeInsets.only(left: 115),
                          child: Text("admin",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: _createDrawerItem(
                        icon: Icons.people, text: 'Employees', index: 0),
                  ),
                  Divider(
                    color: primaryBackgroundColor,
                    indent: 50,
                    endIndent: 50,
                  ),
                  _createDrawerItem(
                      icon: Icons.account_circle, text: 'Profile', index: 1),
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
            ),
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
      textColor: fontColor,
      selectedColor: fontColor,
      selectedTileColor: secondaryColor,
      leading: Icon(
        icon,
        color: fontColor,
      ),
      title: Text(
        text,
        style: const TextStyle(),
      ),
      selected: index == selectedIndex,
      onTap: () => onTap(index),
    );
  }
}
