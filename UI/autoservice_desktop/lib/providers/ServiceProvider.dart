import '../../providers/baseProvider.dart';
import '../../models/Employee/serviceModel.dart';

class ServiceProvider extends BaseProvider<ServiceModel> {
  ServiceProvider() : super('Service');

  @override
  ServiceModel fromJson(data) {
    return ServiceModel.fromJson(data);
  }
}
