import 'package:flutter/material.dart';

var baseUrl = "http://10.0.2.2:7264/";
Color primaryBackgroundColor = const Color(0xFFF9F5EB);
Color fontColor = const Color(0xFFE4DCCF);
Color secondaryColor = const Color(0xFFEA5455);
Color accentColor = const Color(0xFF002B5B);

void showSnackBar(BuildContext context, String message, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
