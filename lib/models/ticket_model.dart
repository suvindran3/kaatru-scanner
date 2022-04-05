import 'package:device_scanner/network/database.dart';
import 'package:latlong2/latlong.dart';

class TicketModel {
  final String userID;
  final String deviceID;
  final String id;
  final String timestamp;
  final LatLng position;
  final String status;

  TicketModel.fromJson(Map<String, dynamic> json)
      : userID = json[param.userID.name],
        deviceID = json[param.deviceID.name],
        id = json[param.ticketID.name],
        timestamp = json[param.timestamp.name],
        position = LatLng(json[param.lat.name], json[param.lng.name]),
        status = json[param.ticketStatus.name];

  TicketModel.init(
      {required this.userID,
      required this.deviceID,
      required this.id,
      required this.timestamp,
      required this.position,
      required this.status});

  Map<String, dynamic> toJson() => {
        param.userID.name: userID,
        param.deviceID.name: deviceID,
        param.ticketID.name: id,
        param.timestamp.name: timestamp,
        param.lat.name: position.latitude,
        param.lat.name: position.longitude,
        param.ticketStatus.name: status,
      };
}
