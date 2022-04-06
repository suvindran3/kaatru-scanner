import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_map.dart';

class MapScreen extends StatelessWidget {
  final LatLng? devicePosition;

  const MapScreen({Key? key, this.devicePosition}) : super(key: key);

  final String googleMapEndpoint = 'https://www.google.com/maps/dir/?api=1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Device Position'),
      ),
      body: Stack(
        children: [
          CustomMap(position: devicePosition),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: ElevatedButton(
                onPressed: openGoogleMaps,
                child: const Text('SHOW DIRECTION'),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(double.maxFinite, 50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openGoogleMaps() async {

    final Position currentPosition = await Geolocator.getCurrentPosition();
    await launch('$googleMapEndpoint&origin=${currentPosition.latitude},'
        '${currentPosition.longitude}&destination=${devicePosition?.latitude}'
        ',${devicePosition?.longitude}&travelmode=driving&dir_action=navigate');
  }
}
