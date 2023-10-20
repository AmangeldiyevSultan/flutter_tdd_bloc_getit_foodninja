import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/rest_repo.dart';

class FetchRestaurants extends UsecaseWithoutParams<List<Restaurant>> {
  const FetchRestaurants(this._repo);

  final RestaurantRepo _repo;

  @override
  ResultFuture<List<Restaurant>> call() => _repo.fetchRestaurants();
}
