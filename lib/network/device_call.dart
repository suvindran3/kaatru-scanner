import 'dart:io';

Future<dynamic> connectToDevice() async {
  dynamic socket;
/*
  10.21.163.100
*/
  try {
    socket = await WebSocket.connect('ws://10.0.2.2:3000/test').timeout(
      const Duration(seconds: 10),
    );
  } catch (e) {
    socket = null;
  }
  return socket;
}
