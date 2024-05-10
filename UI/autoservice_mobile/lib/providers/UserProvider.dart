import 'package:autoservice_mobile/models/userModel.dart';
import '../../providers/baseProvider.dart';

class UserProvider extends BaseProvider<userModel> {
  UserProvider() : super('User');

  @override
  userModel fromJson(data) {
    return userModel.fromJson(data);
  }
}
