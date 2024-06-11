import '../../providers/baseProvider.dart';
import '../models/Admin/vehicleTypeModel.dart';

class VehicleTypeProvider extends BaseProvider<VehicleTypeModel> {
  VehicleTypeProvider() : super('VehicleType');

  @override
  VehicleTypeModel fromJson(data) {
    return VehicleTypeModel.fromJson(data);
  }
}
