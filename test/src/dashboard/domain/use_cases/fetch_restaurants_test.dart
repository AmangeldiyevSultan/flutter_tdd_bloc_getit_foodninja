import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/fetch_restaurants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'restaurant_repo.mock.dart';

void main() {
  late MockRestaurantRepo repo;
  late FetchRestaurants usecase;

  const tRestaurant = <Restaurant>[
    Restaurant.empty(),
  ];

  // const tRestaurant =

  setUp(() {
    repo = MockRestaurantRepo();
    usecase = FetchRestaurants(repo);
  });

  test('should return [Restaurant] from the [RestaurantRepo]', () async {
    // Arrange
    when(
      () => repo.fetchRestaurants(),
    ).thenAnswer((_) async => const Right(tRestaurant));

    //Act
    final result = await usecase();

    //Assert
    expect(result, equals(const Right<dynamic, List<Restaurant>>(tRestaurant)));
  });
}
