import 'package:device_scanner/models/scan_model.dart';
import 'package:device_scanner/operations/operations.dart';
import 'package:geolocator/geolocator.dart';

class MetaDetailsModel {
  final ScanModel scanDetail;
  final String userID;
  final String username;
  final String timestamp;
  final Position position;

  MetaDetailsModel.init(
      {required this.scanDetail,
      required this.userID,
      required this.username,
      required this.position})
      : timestamp = Operations.getTimestamp();
}
