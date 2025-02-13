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
        body: const MapPageBody(),
      ),
    );
  }
}



class MapPageBody extends StatefulWidget {
  const MapPageBody({super.key});

  @override
  State<MapPageBody> createState() => _MapPageBodyState();
}

class _MapPageBodyState extends State<MapPageBody> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;


  Future<void> _createMarkerAtPoint(Point point) async {
    if (pointAnnotationManager == null) return;

    final ByteData bytes = await rootBundle.load('assets/icons/custom-icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    final pointAnnotationOptions = PointAnnotationOptions(
      geometry: point,
      image: imageData,
      iconSize: 3.0,
    );

    await pointAnnotationManager?.create(pointAnnotationOptions);
  }

  void _showPopupAtPoint(BuildContext context, Point point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Location Details'),
                const SizedBox(height: 8),
                Text('Latitude: ${point.coordinates.lat}'),
                Text('Longitude: ${point.coordinates.lng}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _createMarkerAtPoint(point);
                        Navigator.pop(context);
                      },
                      child: Text('Add Marker'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapPageBloc, MapPageState>(
      builder: (context, state) {
        if (state is MapLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MapError) {
          return Center(child: Text(state.message));
        }

        if (state is MapLocationLoaded) {
          final camera = CameraOptions(
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

          return Stack(
            children: [
              MapWidget(
                key: const ValueKey("mapWidget"),
                cameraOptions: camera,
                onMapCreated: (MapboxMap mapBoxMap) async {
                   pointAnnotationManager = await mapBoxMap.annotations.createPointAnnotationManager();
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
                      iconSize: 3.0,);

                  // Agregar la anotación al mapa
                  await pointAnnotationManager?.create(pointAnnotationOptions);
                },
                onTapListener: (MapContentGestureContext coordinate) {
                  final point = Point(
                    coordinates: Position(
                      coordinate.point.coordinates.lng,
                      coordinate.point.coordinates.lat,
                    ),
                  );
                  _showPopupAtPoint(context, point);
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    context.read<MapPageBloc>().add(UpdateUserLocation());
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Something went wrong'));
      },
    );
  }
}