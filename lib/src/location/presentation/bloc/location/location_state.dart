part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<dynamic> get props => [];
}

final class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationError extends LocationState {
  const LocationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class LocationLoaded extends LocationState {
  const LocationLoaded({
    required this.place,
    this.controller,
  });
  final Place place;
  final GoogleMapController? controller;

  @override
  List<dynamic> get props => [place, controller];
}
