import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../components/custom_map.dart';

class MapScreen extends StatelessWidget {
  final LatLng? position;

  const MapScreen({Key? key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Device Position'),
      ),
      body: Stack(
        children: [
          CustomMap(position: position),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: ElevatedButton(
                onPressed: () {},
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
}
