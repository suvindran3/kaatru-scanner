import 'package:device_scanner/components/custom_button.dart';
import 'package:device_scanner/controllers/button_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_map.dart';

class MapScreen extends StatefulWidget {
  final LatLng? devicePosition;

  const MapScreen({Key? key, this.devicePosition}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ButtonController buttonController = ButtonController();

  final String googleMapEndpoint = 'https://www.google.com/maps/dir/?api=1';

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Device Position'),
      ),
      body: Stack(
        children: [
          CustomMap(position: widget.devicePosition),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: CustomButton(
                onTap: openGoogleMaps,
                buttonText: 'SHOW DIRECTION',
                buttonController: buttonController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openGoogleMaps() async {
    buttonController.updateState();
    final Position currentPosition = await Geolocator.getCurrentPosition();
    buttonController.updateState();
    await launch('$googleMapEndpoint&origin=${currentPosition.latitude},'
        '${currentPosition.longitude}&destination=${widget.devicePosition?.latitude}'
        ',${widget.devicePosition?.longitude}&travelmode=driving&dir_action=navigate');
  }
}
