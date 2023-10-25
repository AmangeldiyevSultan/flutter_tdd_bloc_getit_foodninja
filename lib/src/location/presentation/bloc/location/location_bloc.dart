import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/use_cases/get_place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/use_cases/get_place_by_latlng.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/use_cases/get_current_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required GetLocation geoLocation,
    required GetPlace getPlace,
    required GetPlaceByLatLng getPlaceByLatLng,
  })  : _geoLocation = geoLocation,
        _getPlace = getPlace,
        _getPlaceByLatLng = getPlaceByLatLng,
        super(const LocationLoading()) {
    on<LoadMapEvent>(_geoLocationHandler);
    on<SearchLocationEvent>(_onSearchLocationHandler);
    on<LatLngMapEvent>(_geoLatLngHandler);
  }

  final GetLocation _geoLocation;
  final GetPlace _getPlace;
  final GetPlaceByLatLng _getPlaceByLatLng;

  Future<void> _onSearchLocationHandler(
    SearchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _getPlace(event.placeId);
    final state = this.state as LocationLoaded;

    result.fold((failure) => emit(LocationError(failure.message)), (place) {
      state.controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            place!.latitude,
            place.longitude,
          ),
        ),
      );

      emit(
        LocationLoaded(
          place: place,
          controller: state.controller,
        ),
      );
    });
  }

  Future<void> _geoLocationHandler(
    LoadMapEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _geoLocation();
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (place) => emit(
        LocationLoaded(
          controller: event.controller,
          place: Place(
            latitude: place!.latitude,
            longitude: place.longitude,
          ),
        ),
      ),
    );
  }

  Future<void> _geoLatLngHandler(
    LatLngMapEvent event,
    Emitter<LocationState> emit,
  ) async {
    final state = this.state as LocationLoaded;

    final result = await _getPlaceByLatLng(event.latLng!);

    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (place) {
        state.controller!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              place!.latitude,
              place.longitude,
            ),
          ),
        );

        emit(
          LocationLoaded(
            controller: state.controller,
            place: place,
          ),
        );
      },
    );
  }
}
