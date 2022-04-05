import 'package:device_scanner/components/custom_map.dart';
import 'package:device_scanner/components/details_card.dart';
import 'package:device_scanner/models/meta_details_model.dart';
import 'package:device_scanner/screens/debug_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class ScannedScreen extends StatelessWidget {
  const ScannedScreen({Key? key, required this.metaDetails})
      : super(key: key);

  final MetaDetailsModel metaDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomMap(
              position: LatLng(metaDetails.position.latitude,
                  metaDetails.position.longitude),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
              boxShadow: kElevationToShadow[3],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DetailsCard(
                    detailName: 'Device ID',
                    detailValue: metaDetails.scanDetail.deviceID),
                DetailsCard(
                    detailName: 'MAC Address',
                    detailValue: metaDetails.scanDetail.macAddress),
                DetailsCard(
                    detailName: 'User ID',
                    detailValue: metaDetails.userID),
                DetailsCard(
                    detailName: 'Username',
                    detailValue: metaDetails.username),
                DetailsCard(
                    detailName: 'Timestamp',
                    detailValue: metaDetails.timestamp),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () => DebugScreen(metaDetails: metaDetails),
              child: Text(
                'DEBUG DEVICE',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
