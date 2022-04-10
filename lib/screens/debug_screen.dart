import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/models/ticket_model.dart';
import 'package:device_scanner/network/database.dart';
import 'package:device_scanner/network/device_call.dart';
import 'package:device_scanner/operations/operations.dart';
import 'package:device_scanner/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DebugScreen extends StatefulWidget {
  final DeviceModel device;
  const DebugScreen({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
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
      body: !loading
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
                                  top: 20, left: 15, right: 15, bottom: 90),
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
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
                      return const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.brown),
                          ),
                        ),
                      );
                    }
                  },
                )
              : Container()
          : const Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.brown),
                ),
              ),
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
      Operations.handleNetworkError(
        context: context,
        errorMessage: 'Device is not working properly',
        buttonText: 'Raise Ticket'.toUpperCase(),
        callToAction: addTicket,
      );
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> addTicket() async {
    final String ticketID = await Database.getTicketID().then(
      (value) => value.toString(),
    );
    await Database.addTicket(
      context,
      TicketModel.init(
          userID: widget.device.userID,
          deviceID: widget.device.id,
          id: ticketID,
          timestamp: Operations.getTimestamp(),
          lat: widget.device.lat,
          lng: widget.device.lng,
          username: widget.device.username),
    );
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

  Future<void> deploy() async {
    buttonController.updateState();
    await Database.deployDevice(context, widget.device);
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
}
