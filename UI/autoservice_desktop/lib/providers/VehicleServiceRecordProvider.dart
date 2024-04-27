import 'dart:convert';

import 'package:autoservice_desktop/models/Employee/vehicleServiceRecordModel.dart';
import '../../providers/baseProvider.dart';
import '../globals.dart';

class VehicleServiceRecordProvider
    extends BaseProvider<VehicleServiceRecordModel> {
  VehicleServiceRecordProvider() : super('VehicleServiceRecord');

  final String _endpoint = "VehicleServiceRecord";

  Future<List<VehicleServiceRecordModel>> getAllRecordsByVehicle(int id) async {
    var url = "$baseUrl$_endpoint/GetAllRecordsByVehicle?id=$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return List<VehicleServiceRecordModel>.from(
          data.map((x) => VehicleServiceRecordModel.fromJson(x)));
    } else {
      throw Exception("Failed to fetch all records.");
    }
  }

  @override
  VehicleServiceRecordModel fromJson(data) {
    return VehicleServiceRecordModel.fromJson(data);
  }
}
