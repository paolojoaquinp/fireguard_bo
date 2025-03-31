part of 'map_page_bloc.dart';

sealed class MapPageEvent extends Equatable {
  const MapPageEvent();
}

class LoadUserLocation extends MapPageEvent {
  const LoadUserLocation();

  @override
  List<Object?> get props => [];
}

class UpdateUserLocation extends MapPageEvent {
  const UpdateUserLocation();

  @override
  List<Object?> get props => [];
}

class RefreshIncidents extends MapPageEvent {
  const RefreshIncidents();

  @override
  List<Object?> get props => [];
}