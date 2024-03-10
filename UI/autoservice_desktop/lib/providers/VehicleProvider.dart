import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import '../../providers/baseProvider.dart';

class VehicleProvider extends BaseProvider<VehicleModel> {
  VehicleProvider() : super('Vehicle');

  @override
  VehicleModel fromJson(data) {
    return VehicleModel.fromJson(data);
  }
}
