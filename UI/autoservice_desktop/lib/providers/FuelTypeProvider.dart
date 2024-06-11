import '../../providers/baseProvider.dart';
import '../models/Admin/fuelTypeModel.dart';

class FuelTypeProvider extends BaseProvider<FuelTypeModel> {
  FuelTypeProvider() : super('VehicleFuelType');

  @override
  FuelTypeModel fromJson(data) {
    return FuelTypeModel.fromJson(data);
  }
}
