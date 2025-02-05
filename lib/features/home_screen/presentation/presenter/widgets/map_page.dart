import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define las opciones de la cámara (posición inicial del mapa)
    CameraOptions camera = CameraOptions(
      center: Point(coordinates: Position(-98.0, 39.5)), // Centro de USA
      zoom: 3,
      bearing: 0,
      pitch: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Demo'),
      ),
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: camera,
        onMapCreated: (MapboxMap mapboxMap) {
          print("Mapa creado exitosamente");
        },
      ),
    );
  }
}