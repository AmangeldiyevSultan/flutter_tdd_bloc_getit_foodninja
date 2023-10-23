import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place_autocomplete.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationRepo {
  const LocationRepo();

  ResultFuture<Position?> getCurrentLocation();

  ResultFuture<List<PlaceAutocomplete>?> getAutocomplete(String searchInput);

  ResultFuture<Place?> getPlace(String placeId);
}
