import "package:autoservice_desktop/models/updateUserModel.dart";
import "./BaseProvider.dart";
import "../models/userModel.dart";
import "../globals.dart";
import 'dart:convert';

class UserProvider extends BaseProvider<userModel> {
  UserProvider() : super("User");

  final String _endpoint = "User";

  Future<userModel> getByUsername(String username) async {
    var url = "$baseUrl$_endpoint/GetByUsername?username=$username";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return userModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch user by username");
    }
  }

  Future<List<userModel>> getAllEmployees() async {
    var url = "$baseUrl$_endpoint/GetAllEmployees";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return List<userModel>.from(data.map((x) => userModel.fromJson(x)));
    } else {
      throw Exception("Failed to fetch all employees");
    }
  }

  Future<updateUserModel?> updateUser(updateUserModel request) async {
    var url = "$baseUrl$_endpoint/Update";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return updateUserModel.fromJson(data);
    } else {
      throw Exception("Failed to update user data");
    }
  }

  Future<void> deleteUser(String id) async {
    var url = "$baseUrl$_endpoint/Delete?id=$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.delete(uri, headers: headers);

    if (!isValidResponseCode(response)) {
      throw Exception("Failed to delete data");
    }
  }

  Future<void> updateUserActiveStatus(String id, bool active) async {
    var url = "$baseUrl$_endpoint/ChangeActiveStatusUser?id=$id&active=$active";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers);

    if (!isValidResponseCode(response)) {
      throw Exception("Failed to update user data");
    }
  }
}
