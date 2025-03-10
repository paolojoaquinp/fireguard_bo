import 'dart:io';
import 'package:fireguard_bo/core/helpers/location_helper.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/create_incident_screen/presentation/children/incident_form/presenter/page/incident_form.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PreviewPhotoContribution extends StatelessWidget {
  const PreviewPhotoContribution({
    super.key,
    required this.photoPath,
  });

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('Preview camera'),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Image.file(File(photoPath)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async  {
                final point = await _getLocation();
                if (point == null) {
                  return;
                }
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncidentForm(
                      photoPath: photoPath,
                      latitude: point.coordinates.lat.toDouble(),
                      longitude: point.coordinates.lng.toDouble(),
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Point?> _getLocation() async {
    final locationResult = await LocationHelper.getCurrentLocation();

    switch (locationResult) {
      case Success(value: final point):
        return point;
      case Err(value: final failure):
        print('Error: ${failure.message}');
        return null;
    } 
  }
}
