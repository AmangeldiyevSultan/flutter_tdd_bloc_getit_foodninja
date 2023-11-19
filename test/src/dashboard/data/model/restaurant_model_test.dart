import 'dart:convert';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/restaurant_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture/fixture_reader.dart';

class MockRestaurant extends Mock implements Restaurant {}

void main() {
  late RestaurantModel tRestaurantModel;
  setUp(() {
    tRestaurantModel = const RestaurantModel.empty();
  });
  test('should return [Restaurant] type', () async {
    expect(tRestaurantModel, isA<Restaurant>());
  });

  final tMap = jsonDecode(fixture('restaurant.json')) as DataMap;

  // group('fromMap', () {
  //   test('should return a valid [RestaurantModel] from the map', () {
  //     //act
  //     final result = RestaurantModel.fromMap(tMap);
  //     //assert
  //     expect(result, isA<RestaurantModel>());
  //     expect(result, equals(tRestaurantModel));
  //   });

  //   test('should throw an [Error] when the map os invalid', () {
  //     final map = DataMap.from(tMap)..remove('name');

  //     const call = RestaurantModel.fromMap;

  //     expect(() => call(map), throwsA(isA<Error>()));
  //   });
  // });

  group('toMap', () {
    test('should return a valid [DataMap] from the RestaurantModel', () {
      final result = tRestaurantModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [RestaurantModel] with updated values', () {
      final result = tRestaurantModel.copyWith(name: '2');

      expect(result.name, '2');
    });
  });
}
