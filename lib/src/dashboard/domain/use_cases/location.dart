import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/location_repo.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation extends UsecaseWithoutParams<Position?> {
  const GetLocation(this._repo);

  final LocationRepo _repo;

  @override
  ResultFuture<Position?> call() => _repo.getCurrentLocation();
}
