import 'package:device_scanner/components/custom_loading_indicator.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/network/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_screen.dart';
import 'package:latlong2/latlong.dart';

class InstalledDevicesScreen extends StatelessWidget {
  const InstalledDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Devices'),
        leading: const BackButton(),
      ),
      body: FutureBuilder<List<DeviceModel>>(
        future: secureTry(Database.getInstalledDevices()),
        builder: (context, future) {
          if (future.hasData) {
            if (future.data!.isNotEmpty) {
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: List.generate(
                  future.data!.length,
                  (index) => _DeviceCard(
                    device: future.data!.elementAt(index),
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No devices yet'.toUpperCase(),
                  style: GoogleFonts.outfit(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              );
            }
          } else {
            return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffEAEFF3),
            child: Icon(
              Icons.tablet_android_outlined,
              color: Colors.grey,
              size: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Device ${device.id}',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          device.timestamp.split(',')[0],
                          style: GoogleFonts.outfit(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            '.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          device.timestamp.split(',')[1],
                          style: GoogleFonts.outfit(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(
                  devicePosition: LatLng(device.lat, device.lng),
                ),
              ),
            ),
            child: const CircleAvatar(
              radius: 17,
              backgroundColor: Colors.brown,
              child: Icon(
                Icons.location_on,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
