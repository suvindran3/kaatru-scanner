import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/models/ticket_model.dart';
import 'package:device_scanner/network/database.dart';
import 'package:device_scanner/network/device_call.dart';
import 'package:device_scanner/network/push_notification.dart';
import 'package:device_scanner/operations/operations.dart';
import 'package:device_scanner/screens/success_screen.dart';
import 'package:flutter/material.dart';

import '../components/custom_loading_indicator.dart';

class DebugScreen extends StatefulWidget {
  final DeviceModel device;
  const DebugScreen({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen>
    with SingleTickerProviderStateMixin {
  late WebSocket webSocket;
  late bool success;
  bool loading = true;
  final ButtonController buttonController = ButtonController();

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    buttonController.dispose();
    try {
      webSocket.close();
    } catch (e) {
      log(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: secureTry(Database.isDeployedAlready(widget.device.id)),
        builder: (context, future) {
          log('deployment status: ${future.data}');
          if (future.hasData) {
            return !loading
                ? success
                    ? StreamBuilder<dynamic>(
                        stream: webSocket,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final Map<String, dynamic> data =
                                jsonDecode(snapshot.data);
                            final List<String> keys =
                                data.keys.toList(growable: false);
                            final List<dynamic> values =
                                data.values.toList(growable: false);
                            return SafeArea(
                              child: Stack(
                                children: [
                                  ListView(
                                    padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 15,
                                        right: 15,
                                        bottom: 90),
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: kElevationToShadow[3],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            26,
                                            (index) => const ListTile(
                                              title: Text(
                                                'parameter',
                                              ),
                                              trailing: Text(
                                                'value',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!future.data!)
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 20),
                                        child: CustomButton(
                                          buttonController: buttonController,
                                          buttonText: 'DEPLOY DEVICE',
                                          onTap: buttonController.isLoading
                                              ? null
                                              : deploy,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return const CustomLoadingIndicator();
                          }
                        },
                      )
                    : Container()
                : const CustomLoadingIndicator();
          } else {
            return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }

  Future<void> init() async {
    try {
      webSocket = await connectToDevice();
      success = true;
    } catch (e) {
      success = false;
    }
    if (!success) {
      show();
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> addTicket() async {
    final String ticketID = await secureTry(Database.getTicketID()).then(
      (value) => value.toString(),
    );
    final bool ticketExists =
        await secureTry(Database.ticketExists(widget.device.id));
    if (ticketExists) {
      const SnackBar snackBar = SnackBar(
        content: Text('A ticket is already active for this device'),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final String fcmToken =
          await secureTry(Database.getFcmToken(widget.device.id));
      await secureTry(Database.addTicket(
        TicketModel.init(
            userID: widget.device.userID,
            deviceID: widget.device.id,
            id: ticketID,
            timestamp: Operations.getTimestamp(),
            lat: widget.device.lat,
            lng: widget.device.lng,
            username: widget.device.username),
      ));
      if (fcmToken.isNotEmpty) {
        await secureTry(PushNotification().send(fcmToken));
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            id: ticketID,
            forTicket: true,
          ),
        ),
        (Route<dynamic> route) => route.isFirst,
      );
    }
  }

  Future<void> deploy() async {
    buttonController.updateState();
    await secureTry(Database.deployDevice(widget.device));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          id: widget.device.id,
          forTicket: false,
        ),
      ),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  Future<dynamic> show() async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          Transform.scale(
        scale: animation.value,
        child: child,
      ),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Error',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Device is not working properly',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              init();
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shadowColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.brown),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            child: Text('Retry'.toUpperCase()),
          ),
          ElevatedButton(
            onPressed: () {
              addTicket();
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            child: Text('Raise ticket'.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
