import 'dart:convert';
import 'dart:io';
import 'package:device_scanner/models/meta_details_model.dart';
import 'package:device_scanner/network/device_call.dart';
import 'package:device_scanner/operations/operations.dart';
import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  final MetaDetailsModel metaDetails;
  const DebugScreen({Key? key, required this.metaDetails,}) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late WebSocket webSocket;
  late bool success;
  bool loading = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    try {
      webSocket = await connectToDevice(context);
      success = true;
    } catch (e) {
      success = false;
    }
    if (!success) {
      Operations.handleNetworkError(
        context: context,
        errorMessage: 'Device is not working properly',
        buttonText: 'Raise Ticket',
        callToAction: addTicket,
      );
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> addTicket() async {

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
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: kElevationToShadow[3],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      keys.length,
                                      (index) => ListTile(
                                        title: Text(
                                          keys[index].toString(),
                                        ),
                                        trailing: Text(
                                          values[index].toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
}
