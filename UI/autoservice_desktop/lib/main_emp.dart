import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/models/storageService.dart';
import 'package:autoservice_desktop/providers/AuthProvider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import './screens/profile_screen.dart';
import './screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './screens/Employee/cars_screen.dart';
import './screens/Employee/requests_screen.dart';
import './screens/Employee/customers_screen.dart';
import './screens/Employee/services_screen.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

void main() {
  final AuthProvider authProvider = AuthProvider();

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Fluent UI",
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(authProvider: authProvider),
        '/home2': (context) => MyHomePageEmp(title: 'AutoService'),
      },
    );
  }
}

class MyHomePageEmp extends StatefulWidget {
  MyHomePageEmp({Key? key, required this.title, this.storageService})
      : super(key: key);

  final String title;
  final StorageService? storageService;

  @override
  _MyHomePageEmpState createState() => _MyHomePageEmpState();
}

class _MyHomePageEmpState extends State<MyHomePageEmp> {
  int _currentPage = 0;

  void _logout(BuildContext context) async {
    await _storage.delete(key: 'token');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    var storageService =
        ModalRoute.of(context)!.settings.arguments as StorageService?;

    return NavigationView(
      appBar: NavigationAppBar(
        backgroundColor: accentColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AutoService",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: fontColor),
            ),
            const SizedBox(height: 5),
            Text(
              "Welcome ${storageService?.username}",
              style: TextStyle(fontSize: 15, color: fontColor),
            ),
          ],
        ),
      ),
      pane: NavigationPane(
        size: const NavigationPaneSize(
          openMinWidth: 250.0,
          openMaxWidth: 320.0,
        ),
        items: <NavigationPaneItem>[
          PaneItem(
            icon: const Icon(
              Icons.content_copy,
              size: 30,
            ),
            title: const Text(
              "Requests",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            body: RequestsScreen(),
          ),
          PaneItem(
            icon: const Icon(
              FluentIcons.repair,
              size: 30,
            ),
            title: const Text(
              "Services",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            body: ServiceScreen(),
          ),
          PaneItem(
            icon: const Icon(
              FluentIcons.car,
              size: 30,
            ),
            title: const Text(
              "Cars",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            body: CarsScreen(),
          ),
          PaneItem(
            icon: const Icon(
              FluentIcons.group,
              size: 30,
            ),
            title: const Text(
              "Customers",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            body: CustomersScreen(),
          ),
          PaneItem(
            icon: const Icon(
              FluentIcons.profile_search,
              size: 30,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            body: const ProfileScreen(),
          ),
        ],
        selected: _currentPage,
        onChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        footerItems: [
          PaneItem(
            icon: const Icon(
              FluentIcons.sign_out,
              size: 30,
            ),
            title: const Text("Log out",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            onTap: () => _logout(context),
            body: LoginScreen(authProvider: AuthProvider()),
          ),
        ],
      ),
    );
  }
}
