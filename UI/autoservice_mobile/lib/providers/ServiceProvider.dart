import '../../providers/baseProvider.dart';
import '../models/serviceModel.dart';

class ServiceProvider extends BaseProvider<ServiceModel> {
  ServiceProvider() : super('Service');

  @override
  ServiceModel fromJson(data) {
    return ServiceModel.fromJson(data);
  }
}
