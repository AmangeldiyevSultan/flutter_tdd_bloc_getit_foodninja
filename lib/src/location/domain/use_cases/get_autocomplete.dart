import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place_autocomplete.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/repo/location_repo.dart';

class GetAutocomplete
    extends UsecaseWithParams<List<PlaceAutocomplete>?, String> {
  const GetAutocomplete(this._repo);

  final LocationRepo _repo;

  @override
  ResultFuture<List<PlaceAutocomplete>?> call(String params) =>
      _repo.getAutocomplete(params);
}
