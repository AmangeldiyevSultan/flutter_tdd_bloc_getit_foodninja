import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required GetGeoLocation geoLocation,
  })  : _geoLocation = geoLocation,
        super(const LocationLoading()) {
    on<LoadMapEvent>(_geoLocationHandler);
  }

  final GetGeoLocation _geoLocation;

  Future<void> _geoLocationHandler(
    LoadMapEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _geoLocation();
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (position) => emit(
        LocationLoaded(
          controller: event.controller,
          location: position,
        ),
      ),
    );
  }
}
