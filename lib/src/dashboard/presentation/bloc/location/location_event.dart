part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LoadMapEvent extends LocationEvent {
  const LoadMapEvent({this.controller});

  final GoogleMapController? controller;

  @override
  List<Object> get props => [controller!];
}

class SearchLocationEvent extends LocationEvent {
  const SearchLocationEvent({required this.placeId});

  final String placeId;

  @override
  List<Object> get props => [placeId];
}
