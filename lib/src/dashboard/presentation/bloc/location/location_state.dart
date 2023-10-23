part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
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
    this.controller,
    this.location,
  });
  final Position? location;
  final GoogleMapController? controller;

  @override
  List<Object> get props => [controller!, location!];
}
