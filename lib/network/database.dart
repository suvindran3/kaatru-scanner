import 'dart:async';
import 'dart:developer';
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
}

class Database {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final Db _db = Db('mongodb://10.42.168.155:27017/admin');

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

  static Future<void> connect(BuildContext context) async {
    log('connecting');
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
  }

  static Future<void> reconnect() async {
    if (!_db.isConnected) {
      await _db
          .open()
          .timeout(
            const Duration(seconds: 5),
          )
          .onError(
            (error, stackTrace) async => await reconnect(),
          );
    }
  }

  static Future<Map<String, dynamic>?> getUser({required String userID}) async {
    await reconnect();
    return await _db.collection('creds').findOne(
      {param.userID.name: userID},
    );
  }

  static Future<void> saveUser() async => await _secureStorage
      .write(key: param.userID.name, value: user.name)
      .whenComplete(
        () async => await _secureStorage.write(
            key: param.username.name, value: user.id),
      );

  static Future<void> addTicket(
      BuildContext context, TicketModel ticket) async {
    await reconnect();
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

  static Future<List<TicketModel>> getTickets() async {
    await reconnect();
    return await _db.collection('tickets').find().toList().then(
          (value) => List.generate(
            value.length,
            (index) => TicketModel.fromJson(
              value.elementAt(index),
            ),
          ),
        );
  }
}
