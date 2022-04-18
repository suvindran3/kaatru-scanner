import 'dart:convert';
import 'dart:developer';

import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/components/custom_dialog.dart';
import 'package:device_scanner/components/error_dialog.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
    customDialog = CustomDialog.init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
                onTap: () async {},
                buttonText: 'Debug Device'.toUpperCase(),
                buttonController: buttonController),
          ),
        ],
      ),
    );
  }
}

Future<void> send() async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAOk7EGc0:APA91bHUV-34gB8hyoUm1qHvgIuJbVG07pol17OU2fE'
        'zIGz0izJZcPNd--6IKwuZLMMf97FZhvZ6pO5vAlJBvRLILVfsRbaIHXbRCuw_nDitcB9ESz'
        '_tFnO1kk-8MSukNQsynFLI9wrl'
  };
  final Map<String, dynamic> data = {
    "notification": {"title": "Hola", "body": "voilaaaaaaaaaaaa!"},
    "to": "eXqUHmVGTSy5H4mFcGaC-9:APA91bFRp1Ud2ib7H86zUBKtJjSI_-ypcv0U-7Eq5K"
        "ZSLJ2Elf_Yo2CI5rKLDebSs3Sy8aaFxpO7xaeTM8Bz1fphCi8T7u1Ub-fk52-8SiVnYyH_A"
        "ZCfUd38qu_Bkv2x8qUR00jRQzBe",
    "direct_boot_ok": true
  };
  await http
      .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: headers, body: jsonEncode(data))
      .then(
        (value) => log(value.body),
      );
}
