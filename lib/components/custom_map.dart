import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({
    Key? key,
    required this.position,
  }) : super(key: key);

  final LatLng? position;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: position?? LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
          "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          /*attributionBuilder: (_) {
            return const Text("© OpenStreetMap contributors");
          },*/
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              point: position ?? LatLng(51.5, -0.09),
              builder: (context) => const Icon(
                Icons.location_on_rounded,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

