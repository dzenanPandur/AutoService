import 'package:autoservice_desktop/models/Employee/requestModel.dart';
import '../../providers/baseProvider.dart';

class RequestProvider extends BaseProvider<RequestModel> {
  RequestProvider() : super('Request');

  @override
  RequestModel fromJson(data) {
    return RequestModel.fromJson(data);
  }
}
