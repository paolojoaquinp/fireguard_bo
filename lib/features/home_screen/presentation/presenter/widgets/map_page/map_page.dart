import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/features/home_screen/data/repositories_impl/services/incident_service.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/bloc/map_page_bloc.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapPageBloc>(
      create: (context) => MapPageBloc(
        incidentRepository: IncidentService(FirebaseFirestore.instance),
      )..add(const LoadUserLocation()),
      child: const MapPageBody(),
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
          final incidents = state.incidents;
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
                styleUri: MapboxStyles.MAPBOX_STREETS,
                onMapCreated: (MapboxMap mapBoxMap) async {
                  pointAnnotationManager = await mapBoxMap.annotations
                      .createPointAnnotationManager();

                  pointAnnotationManager?.addOnPointAnnotationClickListener(
                    AnnotationClickListener(context: context),
                  );
                  // Cargar el icono para la ubicación actual
                  final ByteData bytes =
                      await rootBundle.load('assets/icons/custom-icon.png');
                  final Uint8List currentLocationIcon =
                      bytes.buffer.asUint8List();

                  // Agregar marker de ubicación actual
                  final currentLocationMarker = PointAnnotationOptions(
                    geometry: Point(
                      coordinates: Position(
                        state.position.longitude,
                        state.position.latitude,
                      ),
                    ),
                    image: currentLocationIcon,
                    iconSize: 3.0,
                  );
                  await pointAnnotationManager?.create(currentLocationMarker);
                  final ByteData incidentBytes = await rootBundle
                      .load('assets/icons/marker-fire-icon.png');
                  final Uint8List incidentIcon =
                      incidentBytes.buffer.asUint8List();
                  // Si hay incidentes, agregar sus markers
                  incidents.listen((incidentList) async {
                    // Clear any previous incident markers
                    await pointAnnotationManager?.deleteAll();
                    // Re-add the current location marker
                    await pointAnnotationManager?.create(currentLocationMarker);
                    
                    final incidentMarkers = incidentList
                        .map(
                          (incident) {
                            final marker = PointAnnotationOptions(
                              geometry: Point(
                                coordinates: Position(
                                  incident.location.long,
                                  incident.location.lat,
                                ),
                              ),
                              image: incidentIcon,
                              iconSize: 2.5,
                              textField: incident.id,
                              textOpacity: 0,
                            );
                            return marker;
                          },
                        )
                        .toList();
                    await pointAnnotationManager?.createMulti(incidentMarkers);
                  });
                },
                onTapListener: (MapContentGestureContext coordinate) {
                  final point = Point(
                    coordinates: Position(
                      coordinate.point.coordinates.lng,
                      coordinate.point.coordinates.lat,
                    ),
                  );
                  print("LNG ${coordinate.point.coordinates.lng}");
                  print("LAT ${coordinate.point.coordinates.lat}");
                  // _showPopupAtPoint(context, point);
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

class AnnotationClickListener extends OnPointAnnotationClickListener {
  AnnotationClickListener({
    required this.context,
  });
  final BuildContext context;

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    _showPopupAtPoint(context, annotation.geometry, annotation.textField);
    print("onAnnotationClick, id: ${annotation.id}");
  }

  void _showPopupAtPoint(BuildContext context, Point point, String? incidentId) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 80.0,
          ),
          child: PopupMenu(
            point: point,
            incidentId: incidentId,
            onClose: () => Navigator.pop(context),
            onSubmit: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // Future<void> _createMarkerAtPoint(Point point) async {
  //   if (pointAnnotationManager == null) return;

  //   final ByteData bytes =
  //       await rootBundle.load('assets/icons/custom-icon.png');
  //   final Uint8List imageData = bytes.buffer.asUint8List();

  //   final pointAnnotationOptions = PointAnnotationOptions(
  //     geometry: point,
  //     image: imageData,
  //     iconSize: 3.0,
  //   );

  //   await pointAnnotationManager?.create(pointAnnotationOptions);
  // }
}
