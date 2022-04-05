import 'package:device_scanner/network/database.dart';

class UserModel {
  final String name;
  final String id;

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json[param.username.name]?? '',
        id = json[param.userID.name]?? '';


}
