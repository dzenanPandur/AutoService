import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var baseUrl = "https://localhost:7264/";
Color primaryBackgroundColor = const Color(0xFFF9F5EB);
Color fontColor = const Color(0xFFE4DCCF);
Color secondaryColor = const Color(0xFFEA5455);
Color accentColor = const Color(0xFF002B5B);
double txtWidthDetails = 8;

Widget buildDropdown(
    String label, List<String> options, TextEditingController controller) {
  String initialValue = options.isNotEmpty ? options[0] : '';
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
    child: SizedBox(
      width: 230,
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty && options.contains(controller.text)
            ? controller.text
            : initialValue,
        onChanged: (String? value) {
          controller.text = value!;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ),
  );
}

Widget buildRow(
  String label,
  TextEditingController controller,
  bool editable,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 230,
          child: TextField(
            controller: controller,
            readOnly: editable,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildPasswordRow(String label, TextEditingController controller) {
  bool isObscure = true;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 230,
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
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
        SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDatePicker(
    String label, BuildContext context, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: 230,
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

            controller.text = formattedDate;
          }
        },
      ),
    ),
  );
}
