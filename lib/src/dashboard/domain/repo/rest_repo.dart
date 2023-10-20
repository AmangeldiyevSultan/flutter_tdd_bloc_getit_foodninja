import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';

abstract class RestaurantRepo {
  const RestaurantRepo();

  ResultFuture<void> createRestaurant({
    required String name,
    required String image,
    required RestLocation location,
    required String description,
  });

  ResultFuture<List<Restaurant>> fetchRestaurants();
}
