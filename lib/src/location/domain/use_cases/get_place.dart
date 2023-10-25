import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/repo/location_repo.dart';

class GetPlace extends UsecaseWithParams<Place?, String> {
  const GetPlace(this._repo);

  final LocationRepo _repo;

  @override
  ResultFuture<Place?> call(String params) => _repo.getPlace(params);
}
