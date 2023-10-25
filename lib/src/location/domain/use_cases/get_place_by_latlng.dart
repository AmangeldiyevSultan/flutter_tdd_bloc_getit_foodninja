import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/repo/location_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPlaceByLatLng extends UsecaseWithParams<Place?, LatLng> {
  const GetPlaceByLatLng(this._repo);

  final LocationRepo _repo;

  @override
  ResultFuture<Place?> call(LatLng params) => _repo.getPlaceByLatLng(params);
}
