import 'dart:convert';
import '../globals.dart';
import '../models/request/requestModel.dart';
import '../models/request/updateRequestModel.dart';
import 'BaseProvider.dart';

class RequestProvider extends BaseProvider<RequestModel> {
  RequestProvider() : super('Request');
  final _endpoint = "Request";
  @override
  RequestModel fromJson(data) {
    return RequestModel.fromJson(data);
  }

  Future<UpdateRequestModel?> updateRequest(UpdateRequestModel request) async {
    var url = "$baseUrl$_endpoint/Update";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return UpdateRequestModel.fromJson(data);
    } else {
      throw Exception("Failed to update user data");
    }
  }
}
