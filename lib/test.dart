import 'dart:developer';

import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:device_scanner/network/database.dart';
import 'package:device_scanner/network/device_call.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final ButtonController buttonController = ButtonController();

  @override
  void initState() {
    Database.reconnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
                onTap: () async {
                  buttonController.updateState();
                  await Database.getInstalledDevices(context);
                  buttonController.updateState();
                },
                buttonText: 'Debug Device'.toUpperCase(),
                buttonController: buttonController),
          ),
        ],
      ),
    );
  }
}
