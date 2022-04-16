import 'package:device_scanner/network/database.dart';

class UserModel {
  final String name;
  final String id;
  final String fcmToken;

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json[param.username.name] ?? '',
        id = json[param.userID.name] ?? '',
        fcmToken = json[param.fcmToken.name] ?? '';
}
