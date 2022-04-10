import 'dart:async';
import 'dart:developer';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/models/ticket_model.dart';
import 'package:flutter/cupertino.dart';
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
  macAddress
}

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
  }

  static Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }

  static Future<Db> connect(BuildContext context) async {
    log('connecting');
    _db = await Db.create(
            'mongodb+srv://suvindran:pXNfQXTYsTZ5H1ZE@kaatru.gnrmu.mongodb.net/kaatru')
        .onError(
      (error, stackTrace) async {
        log(error.toString());
        await Operations.handleNetworkError(
          context: context,
          errorMessage: 'Server seems to be down. Please try again later',
          callToAction: () async => await connect(context),
        );
        return await connect(context);
      },
    );
    await _db.open().onError(
      (error, stackTrace) async {
        log(error.toString());
        await Operations.handleNetworkError(
          context: context,
          errorMessage: 'Server seems to be down. Please try again later',
          callToAction: () async => await connect(context),
        );
      },
    ).timeout(
      const Duration(seconds: 10),
    );
    log(_db.isConnected.toString());
    if (_db.isConnected) {
      await Operations.navigate(context);
    }
    return _db;
  }

  static Future<void> reconnect() async {
    if (!_db.isConnected) {
      log('reconnecting');
      await _db.open().timeout(
            const Duration(seconds: 5),
          );
    }
    timer = Timer.periodic(
      const Duration(seconds: 10),
          (timer) => reconnect(),
    );
  }

  static Future<Map<String, dynamic>?> getUser(BuildContext context,
      {required String userID}) async {
    return await _db.collection('creds').findOne(
      {param.userID.name: userID},
    );
  }

  static Future<void> saveUser() async => await _secureStorage
      .write(key: param.userID.name, value: user.id)
      .whenComplete(
        () async => await _secureStorage.write(
            key: param.username.name, value: user.name),
      );

  static Future<int> getTicketID() async =>
      await _db.collection('tickets').count() + 1;

  static Future<void> addTicket(
      BuildContext context, TicketModel ticket) async {
    await _db.collection('tickets').insert(ticket.toJson()).onError(
      (error, stackTrace) async {
        await Operations.handleNetworkError(
          context: context,
          errorMessage: 'Server seems to be down. Please try again later',
          callToAction: () async => await addTicket(context, ticket),
        );
        return ticket.toJson();
      },
    ).timeout(
      const Duration(seconds: 10),
    );
  }

  static Future<void> deployDevice(
      BuildContext context, DeviceModel device) async {
    await _db.collection('installedDevices').insert(
          device.toJson(),
        );
  }

  static Future<List<DeviceModel>> getInstalledDevices(
      BuildContext context) async {
    final Map<String, dynamic> query = {
      param.userID.name: user.id,
    };
    return await _db
        .collection('installedDevices')
        .find(query)
        .toList()
        .then(
          (value) => List.generate(
            value.length,
            (index) => DeviceModel.fromJson(
              value.elementAt(index),
            ),
          ),
        )
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        log('Timeout error');
        return getInstalledDevices(context);
      },
    ).onError(
      (error, stackTrace) async {
        await Operations.handleNetworkError(
          context: context,
          errorMessage: 'Server seems to be down. Please try again later',
          callToAction: () {},
        );
        return getInstalledDevices(context);
      },
    );
  }

  static Future<List<TicketModel>> getTickets(BuildContext context) async {
    return await _db
        .collection('tickets')
        .find()
        .toList()
        .then(
          (value) => List.generate(
            value.length,
            (index) => TicketModel.fromJson(
              value.elementAt(index),
            ),
          ),
        )
        .onError(
      (error, stackTrace) async {
        Operations.handleNetworkError(
          context: context,
          errorMessage: 'errorMessage',
          callToAction: () {},
        );
        return getTickets(context);
      },
    );
  }
}
