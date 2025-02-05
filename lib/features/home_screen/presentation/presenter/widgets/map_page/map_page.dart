import 'dart:typed_data';

import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/bloc/map_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapPageBloc>(
      create: (context) => MapPageBloc()..add(LoadUserLocation()),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mapbox Demo'),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapPageBloc, MapPageState>(
      builder: (context, state) {
        if (state is MapLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MapError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }
        if (state is MapLocationLoaded) {
          CameraOptions camera = CameraOptions(
            center: Point(
              coordinates: Position(
                state.position.longitude,
                state.position.latitude,
              ),
            ),
            zoom: 15,
            bearing: 0,
            pitch: 0,
          );

          return Scaffold(
            appBar: AppBar(title: const Text('Mi Ubicación')),
            body: MapWidget(
              key: const ValueKey("mapWidget"),
              cameraOptions: camera,
              onMapCreated: (MapboxMap mapboxMap) async {
                final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

                final ByteData bytes = await rootBundle.load('assets/icons/custom-icon.png');
                final Uint8List imageData = bytes.buffer.asUint8List();

                final pointAnnotationOptions = PointAnnotationOptions(
                    geometry: Point(
                      coordinates: Position(
                        state.position.longitude,
                        state.position.latitude,
                      ),
                    ),
                    image: imageData,
                    iconSize: 3.0);

                // Agregar la anotación al mapa
                await pointAnnotationManager.create(pointAnnotationOptions);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<MapPageBloc>().add(UpdateUserLocation());
              },
              child: const Icon(Icons.my_location),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
      },
    );
  }
}
