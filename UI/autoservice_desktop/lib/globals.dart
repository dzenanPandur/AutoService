import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var baseUrl = "http://localhost:7264/";
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

Widget buildDropdown(
    String label, List<String> options, TextEditingController controller,
    {String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
    child: SizedBox(
      width: 230,
      child: DropdownButtonFormField<String>(
        value: null,
        onChanged: (String? value) {
          controller.text = value!;
        },
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          border: const OutlineInputBorder(),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: validator,
      ),
    ),
  );
}

Widget buildRow(String label, TextEditingController controller, bool editable,
    TextInputType? inputType, int? characters,
    {String? Function(String?)? validator,
    String? helperText,
    String? errorText,
    var key,
    var onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 230,
          child: TextFormField(
            controller: controller,
            readOnly: editable,
            keyboardType: inputType,
            maxLength: characters,
            key: key,
            decoration: InputDecoration(
                labelText: label,
                floatingLabelStyle: TextStyle(color: secondaryColor),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                helperText: helperText,
                errorText: errorText),
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

Widget buildPasswordRow(String label, TextEditingController controller,
    {String? Function(String?)? validator}) {
  bool isObscure = true;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 230,
          child: TextFormField(
            controller: controller,
            obscureText: isObscure,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              floatingLabelStyle: TextStyle(color: secondaryColor),
              border: const OutlineInputBorder(),
            ),
            validator: validator,
          ),
        ),
      ],
    ),
  );
}

Widget buildCheckboxRow(
  String labelText,
  TextEditingController controller,
  bool isReadOnly,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(labelText),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDatePicker(
    String label, BuildContext context, TextEditingController controller,
    {String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: 230,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: secondaryColor),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            fieldHintText: "dd/mm/yyyy",
            locale: const Locale("en", "GB"),
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

            controller.text = formattedDate;
          }
        },
        validator: validator,
      ),
    ),
  );
}
