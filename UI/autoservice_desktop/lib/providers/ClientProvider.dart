import 'dart:convert';
import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/models/userModel.dart';
import '../../providers/baseProvider.dart';
import '../globals.dart';

class ClientProvider extends BaseProvider<userModel> {
  ClientProvider() : super('Client');

  final String _endpoint = "Client";

  @override
  userModel fromJson(data) {
    return userModel.fromJson(data);
  }

  Future<List<VehicleModel>> getAllVehiclesByClient(String id) async {
    var url = "$baseUrl$_endpoint/GetAllVehiclesByClient?id=$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return List<VehicleModel>.from(data.map((x) => VehicleModel.fromJson(x)));
    } else {
      throw Exception("Failed to fetch all vehicles.");
    }
  }
}
