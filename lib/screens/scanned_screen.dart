import 'package:device_scanner/components/custom_map.dart';
import 'package:device_scanner/components/details_card.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/screens/debug_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class ScannedScreen extends StatelessWidget {
  const ScannedScreen({Key? key, required this.device}) : super(key: key);

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[3],
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomMap(
              position: LatLng(device.lat, device.lng),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              boxShadow: kElevationToShadow[3],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DetailsCard(detailName: 'Device ID', detailValue: device.id),
                DetailsCard(
                    detailName: 'MAC Address', detailValue: device.macAddress),
                DetailsCard(detailName: 'User ID', detailValue: device.userID),
                DetailsCard(
                    detailName: 'Username', detailValue: device.username),
                DetailsCard(
                    detailName: 'Timestamp', detailValue: device.timestamp),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DebugScreen(device: device),
                ),
              ),
              child: Text(
                'DEBUG DEVICE',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.brown,
                ),
                fixedSize: MaterialStateProperty.all(
                  const Size(double.maxFinite, 50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
