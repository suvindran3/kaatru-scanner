import 'dart:io';
import 'package:flutter/material.dart';

Future<dynamic> connectToDevice(BuildContext context) async {
  dynamic socket;

  try {
    socket = await WebSocket.connect('ws://10.21.163.100:3000/test').timeout(
      const Duration(seconds: 10),
    );
  } catch (e) {
    socket = null;
  }
  return socket;
}
