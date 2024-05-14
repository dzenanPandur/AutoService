import 'package:autoservice_mobile/models/appointmentModel.dart';
import '../../providers/baseProvider.dart';

class AppointmentProvider extends BaseProvider<AppointmentModel> {
  AppointmentProvider() : super('Appointment');

  @override
  AppointmentModel fromJson(data) {
    return AppointmentModel.fromJson(data);
  }
}
