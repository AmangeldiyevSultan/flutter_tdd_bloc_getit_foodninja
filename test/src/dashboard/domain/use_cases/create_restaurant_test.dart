import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/create_restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'restaurant_repo.mock.dart';

void main() {
  late MockRestaurantRepo repo;
  late CreateRestaurant usecase;

  const tName = 'Test name';
  const tDescription = 'Test description';
  const tImage = 'Test image';
  const tLocation = RestLocation.empty();

  setUp(() {
    repo = MockRestaurantRepo();
    usecase = CreateRestaurant(repo);
  });

  test('should call the [RestaurantRepo]', () async {
    // Arrange
    when(
      () => repo.createRestaurant(
        name: tName,
        image: tImage,
        location: tLocation,
        description: tDescription,
      ),
    ).thenAnswer((_) async => const Right(null));

    //Act
    final result = await usecase(
      const CreateRestaurantPararms(
        name: tName,
        decoration: tDescription,
        image: tImage,
        location: tLocation,
      ),
    );

    //Assert
    expect(result, equals(const Right<dynamic, void>(null)));
  });
}
