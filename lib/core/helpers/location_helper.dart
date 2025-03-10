import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class LocationHelper {
  const LocationHelper._();

  static Future<Result<mapbox.Point, Failure>> getCurrentLocation() async {
    try {
      final serviceEnabled = await _checkLocationService();
      if (serviceEnabled case Err(value: final failure)) {
        return Err(failure);
      }

      final permissionGranted = await _checkAndRequestPermission();
      if (permissionGranted case Err(value: final failure)) {
        return Err(failure);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return Success(
        mapbox.Point(
          coordinates: mapbox.Position(
            position.longitude,
            position.latitude,
          ),
        ),
      );
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  static Future<Result<bool, Failure>> _checkLocationService() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Err(
        Failure(message: 'Location services are disabled'),
      );
    }
    return Success(true);
  }

  static Future<Result<bool, Failure>> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Err(
          Failure(message: 'Location permissions are denied'),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Err(
        Failure(
          message: 'Location permissions are permanently denied. Please enable them in settings.',
        ),
      );
    }

    return Success(true);
  }

  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Updates every 10 meters
      ),
    );
  }
}