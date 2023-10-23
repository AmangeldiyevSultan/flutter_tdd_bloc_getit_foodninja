import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/getlocation_repo.dart';
import 'package:geolocator/geolocator.dart';

class GetGeoLocation extends UsecaseWithoutParams<Position?> {
  const GetGeoLocation(this._repo);

  final GeoLocationRepo _repo;

  @override
  ResultFuture<Position?> call() => _repo.getCurrentLocation();
}