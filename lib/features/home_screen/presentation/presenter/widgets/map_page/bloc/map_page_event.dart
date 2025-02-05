part of 'map_page_bloc.dart';

sealed class MapPageEvent extends Equatable {
  const MapPageEvent();

  @override
  List<Object> get props => [];
}


class LoadUserLocation extends MapPageEvent {}

class UpdateUserLocation extends MapPageEvent {}