import '../../providers/baseProvider.dart';
import '../models/requestModel.dart';

class RequestProvider extends BaseProvider<RequestModel> {
  RequestProvider() : super('Request');

  @override
  RequestModel fromJson(data) {
    return RequestModel.fromJson(data);
  }
}
