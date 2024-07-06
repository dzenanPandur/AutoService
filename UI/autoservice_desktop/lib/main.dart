import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/models/storageService.dart';
import 'package:autoservice_desktop/screens/Admin/home_screen.dart';
import 'package:autoservice_desktop/screens/Employee/home_screen.dart';
import 'package:autoservice_desktop/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'providers/AuthProvider.dart';

void main() {
  final AuthProvider authProvider = AuthProvider();

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final storageService = settings.arguments as StorageService;
          return MaterialPageRoute(
              builder: (context) => HomeAdminScreen(
                  authProvider: authProvider, storageService: storageService));
        } else if (settings.name == '/home2') {
          final storageService = settings.arguments as StorageService;
          return MaterialPageRoute(
              builder: (context) => HomeEmployeeScreen(
                  authProvider: authProvider, storageService: storageService));
        }
        return null;
      },
      title: 'AutoService',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ),
      ),
      home: LoginScreen(authProvider: authProvider),
    );
  }
}
