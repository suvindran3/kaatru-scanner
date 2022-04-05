import 'package:device_scanner/components/error_dialog.dart';
import 'package:device_scanner/screens/home_screen.dart';
import 'package:device_scanner/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../network/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ErrorDialog.show(context,
          'We need access to your location in order to proceed further',
          action: checkPermission);
    } else if (permission == LocationPermission.deniedForever) {
      ErrorDialog.show(
          context,
          'We need access to your location in order to proceed further. Since '
          'you\'ve denied the access forever you\'ll have to change '
          'that in the app settings',
          action: checkPermission);
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      init();
    }
  }

  Future<void> init() async {
    await Database.isSignedIn();
    await Database.connect(context);
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'KAATRU',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}