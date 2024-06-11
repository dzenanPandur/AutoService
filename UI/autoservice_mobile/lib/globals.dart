import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

var baseUrl = "http://10.0.2.2:7264/";
Color primaryBackgroundColor = const Color(0xFFF9F5EB);
Color fontColor = const Color(0xFFE4DCCF);
Color secondaryColor = const Color(0xFFEA5455);
Color accentColor = const Color(0xFF002B5B);

void showSnackBar(BuildContext context, String message, Color color) {
  Flushbar(
    message: message,
    duration: const Duration(milliseconds: 1500),
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: color,
    borderColor: fontColor,
    borderWidth: 0.5,
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}
