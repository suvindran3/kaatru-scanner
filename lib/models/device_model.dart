import 'package:device_scanner/network/database.dart';
import 'package:device_scanner/operations/operations.dart';

class DeviceModel {
  final String userID;
  final String username;
  final String timestamp;
  final double lat;
  final double lng;
  final String id;

  DeviceModel.init(
      {required this.id,
      required this.userID,
      required this.username,
      required this.lat,
      required this.lng})
      : timestamp = Operations.getTimestamp();

  DeviceModel.fromJson(Map<String, dynamic> json)
      : userID = json[param.userID.name],
        username = json[param.username.name],
        id = json[param.deviceID.name],
        timestamp = json[param.timestamp.name],
        lat = json[param.lat.name],
        lng = json[param.lng.name];

  Map<String, dynamic> toJson() => {
        param.username.name: username,
        param.userID.name: userID,
        param.timestamp.name: timestamp,
        param.lat.name: lat,
        param.lng.name: lng,
        param.deviceID.name: id,
      };
}
