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
  
  const MapLocationLoaded({required this.position});
  
  @override
  List<Object?> get props => [position];
}

class MapError extends MapPageState {
  final String message;
  
  const MapError(this.message);
  
  @override
  List<Object?> get props => [message];
}