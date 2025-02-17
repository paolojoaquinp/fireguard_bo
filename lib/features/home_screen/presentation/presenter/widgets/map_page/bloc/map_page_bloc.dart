import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident.dart';
import 'package:fireguard_bo/features/home_screen/domain/repositories/incident_repository.dart';
import 'package:geolocator/geolocator.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  MapPageBloc({
    required this.incidentRepository,
  }) : super(const MapPageInitial()) {
    on<MapPageEvent>((event, emit) {});
    on<LoadUserLocation>(_onLoadUserLocation);
    on<UpdateUserLocation>(_onUpdateUserLocation);
  }

  final IncidentRepository incidentRepository;

  Future<void> _onLoadUserLocation(
      LoadUserLocation event, Emitter<MapPageState> emit) async {
    emit(const MapLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const MapError('Location services are disabled'));
        return;
      }

      final incidents = await incidentRepository.getIncidents();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const MapError('Location permissions are denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          const MapError(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return switch (incidents) {
        Success(value: final incidents) => emit(
            MapLocationLoaded(
              position: position,
              incidents: incidents,
            ),
          ),
        Err(value: final failure) => emit(MapError('Error getting location: ${failure.message}')),
      };
    } catch (e) {
      emit(MapError('Error getting location: $e'));
    }
  }

  Future<void> _onUpdateUserLocation(
      UpdateUserLocation event, Emitter<MapPageState> emit) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
        // desiredAccuracy: LocationAccuracy.high
      );
      emit(MapLocationLoaded(position: position, incidents: [],));
    } catch (e) {
      emit(MapError('Error updating location: $e'));
    }
  }
}
