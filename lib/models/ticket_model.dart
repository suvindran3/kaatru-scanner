import 'package:device_scanner/network/database.dart';

class TicketModel {
  final String userID;
  final String username;
  final String deviceID;
  final String id;
  final String timestamp;
  final double lat;
  final double lng;
  final String status;

  TicketModel.fromJson(Map<String, dynamic> json)
      : userID = json[param.userID.name],
        deviceID = json[param.deviceID.name],
        username = json[param.username.name],
        id = json[param.ticketID.name],
        timestamp = json[param.timestamp.name],
        lat = json[param.lat.name],
        lng = json[param.lng.name],
        status = json[param.ticketStatus.name];

  TicketModel.init(
      {required this.userID,
      required this.deviceID,
      required this.id,
      required this.timestamp,
      required this.lat,
      required this.lng,
      this.status = 'open',
      required this.username});

  Map<String, dynamic> toJson() => {
        param.userID.name: userID,
        param.deviceID.name: deviceID,
        param.ticketID.name: id,
        param.username.name: username,
        param.timestamp.name: timestamp,
        param.lat.name: lat,
        param.lng.name: lng,
        param.ticketStatus.name: status,
      };
}
