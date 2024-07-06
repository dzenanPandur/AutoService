import 'dart:convert';

import 'package:autoservice_mobile/models/userModel.dart';
import '../../providers/baseProvider.dart';
import '../globals.dart';

class UserProvider extends BaseProvider<userModel> {
  UserProvider() : super('User');

  final String _endpoint = "User";

  @override
  userModel fromJson(data) {
    return userModel.fromJson(data);
  }

  Future<bool> checkUsernameExists(
      String username, String currentUserId) async {
    var url =
        "$baseUrl$_endpoint/CheckUsernameExists?username=$username&currentUserId=$currentUserId";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['exists'];
    } else {
      return false;
    }
  }

  Future<bool> checkEmailExists(String email, String currentUserId) async {
    var url =
        "$baseUrl$_endpoint/CheckEmailExists?email=$email&currentUserId=$currentUserId";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['exists'];
    } else {
      return false;
    }
  }
}
