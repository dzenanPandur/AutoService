import 'package:autoservice_mobile/models/vehicleModel.dart';
import '../../providers/baseProvider.dart';

class VehicleProvider extends BaseProvider<VehicleModel> {
  VehicleProvider() : super('Vehicle');

  @override
  VehicleModel fromJson(data) {
    return VehicleModel.fromJson(data);
  }
}
