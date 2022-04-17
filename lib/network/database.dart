import 'dart:async';
import 'dart:developer';
import 'package:device_scanner/main.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/models/ticket_model.dart';
import 'package:device_scanner/network/push_notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/user_model.dart';
import '../operations/operations.dart';

enum param {
  username,
  userID,
  password,
  deviceID,
  timestamp,
  lat,
  lng,
  ticketStatus,
  ticketID,
  macAddress,
  fcmToken
}

/// A future wrapper to handle error and timeout to retry the given future until
/// the future completes

Future<T> secureTry<T>(Future<T> future) async =>
    future.timeout(const Duration(seconds: 5)).onError(
      (error, stackTrace) async {
        await Future.delayed(
          const Duration(seconds: 5),
        );
        return await secureTry(future);
      },
    );

class Database {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static late Db _db;
  static late Timer timer;

  static UserModel user = UserModel.fromJson({});

  static Future<void> isSignedIn() async {
    final bool signedIn =
        await _secureStorage.containsKey(key: param.userID.name);
    if (signedIn) {
      final Map<String, dynamic> userDetails = await _secureStorage.readAll();
      user = UserModel.fromJson(userDetails);
    }
    return;
  }

  static Future<void> signOut() async => await _secureStorage.deleteAll();

  static Future<void> connect({bool reconnection = false}) async {
    log('connecting');
    try {
      _db = await Db.create(
          'mongodb+srv://suvindran:pXNfQXTYsTZ5H1ZE@kaatru.gnrmu.mongodb.net/kaatru');
      await _db.open();
      log('connected');
    } catch (e) {
      log('connection error');
      await Operations.handleNetworkError(
        context: kNavigatorKey.currentContext!,
        errorMessage: 'Server seems to be down. Please try again later',
        callToAction: () async {
          if (!reconnection) {
            await connect();
          }
        },
      );
      return;
    }
    if (_db.isConnected && !reconnection) {
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (timer) async => await reconnect(),
      );
      await Operations.navigate();
    }
    return;
  }

  static Future<void> reconnect() async {
    if (!_db.isConnected) {
      log('reconnecting');
      await connect(reconnection: true);
    }
    return;
  }

  static Future<Map<String, dynamic>?> getUser({required String userID}) async {
    return await _db.collection('creds').findOne(
      {param.userID.name: userID},
    );
  }

  static Future<void> addFcmToken() async {
    final String token = await PushNotification().getFcmToken();
    final Map<String, dynamic> query = {param.userID.name: user.id};
    final Map<String, dynamic> update = {
      '\$set': {
        'token': token,
      }
    };
    if (token.isNotEmpty) {
      await _db.collection('creds').updateOne(query, update);
    }
  }

  static Future<void> saveUser() async => await _secureStorage
      .write(key: param.userID.name, value: user.id)
      .whenComplete(
        () async => await _secureStorage.write(
            key: param.username.name, value: user.name),
      );

  static Future<int> getTicketID() async =>
      await _db
          .collection('tickets')
          .count()
          .onError((error, stackTrace) async => await getTicketID()) +
      1;

  static Future<bool> ticketExists(String deviceID) async {
    final Map<String, dynamic> query = {param.deviceID.name: deviceID};
    return !await _db.collection('tickets').find(query).isEmpty;
  }

  static Future<Map<String, dynamic>> addTicket(TicketModel ticket) async =>
      await _db.collection('tickets').insert(ticket.toJson());

  static Future<Map<String, dynamic>> deployDevice(DeviceModel device) async =>
      await _db.collection('installedDevices').insert(device.toJson());

  static Future<List<DeviceModel>> getInstalledDevices() async {
    final Map<String, dynamic> query = {
      param.userID.name: user.id,
    };
    return await _db.collection('installedDevices').find(query).toList().then(
          (value) => List.generate(
            value.length,
            (index) => DeviceModel.fromJson(
              value.elementAt(index),
            ),
          ),
        );
  }

  static Future<List<TicketModel>> getTickets() async {
    final Map<String, dynamic> query = {param.userID.name: user.id};
    return await _db.collection('tickets').find(query).toList().then(
          (value) => List.generate(
            value.length,
            (index) => TicketModel.fromJson(
              value.elementAt(index),
            ),
          ),
        );
  }

  static Future<bool> isDeployedAlready(String deviceID) async {
    final Map<String, String> query = {param.deviceID.name: deviceID};

    return await _db.collection('installedDevices').findOne(query).then(
          (value) => value != null && value.isNotEmpty ? true : false,
        );
  }

  static Future<String> getFcmToken(String deviceID) async {
    final Map<String, String> query = {param.deviceID.name: deviceID};
    final String token =
        await _db.collection('installedDevices').findOne(query).then(
      (value) async {
        if (value != null && value.isNotEmpty) {
          final DeviceModel device = DeviceModel.fromJson(value);
          return await Database.getUser(userID: device.userID)
              .then((value) => UserModel.fromJson(value ?? {}).fcmToken);
        } else {
          return '';
        }
      },
    );
    return token;
  }
}
