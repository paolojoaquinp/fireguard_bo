part of 'map_page_bloc.dart';

sealed class MapPageState extends Equatable {
  const MapPageState();
}

final class MapPageInitial extends MapPageState {
  const MapPageInitial();

  @override
  List<Object> get props => [];
}

class MapLoading extends MapPageState {
  const MapLoading();

  @override
  List<Object> get props => [];
}

class MapLocationLoaded extends MapPageState {
  final Position position;
  final List<Incident> incidents;

  const MapLocationLoaded({
    required this.position,
    required this.incidents,
  });

  @override
  List<Object?> get props => [position, incidents];
}

class MapError extends MapPageState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
