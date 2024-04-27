import '../../providers/baseProvider.dart';
import '../models/transmissionTypeModel.dart';

class TransmissionTypeProvider extends BaseProvider<TransmissionTypeModel> {
  TransmissionTypeProvider() : super('TransmissionType');

  @override
  TransmissionTypeModel fromJson(data) {
    return TransmissionTypeModel.fromJson(data);
  }
}
