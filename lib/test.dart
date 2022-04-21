import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/components/custom_dialog.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  final ButtonController buttonController = ButtonController();
  late CustomDialog customDialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: const RiveAnimation.asset('images/loading-indicator.riv'),
    );
  }
}
