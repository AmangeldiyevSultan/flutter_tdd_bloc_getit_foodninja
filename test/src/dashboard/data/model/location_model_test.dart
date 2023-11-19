import 'dart:convert';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/location_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture/fixture_reader.dart';

class MockLocation extends Mock implements RestLocation {}

void main() {
  late LocationModel tLocationModel;
  setUp(() {
    tLocationModel = const LocationModel.empty();
  });
  test('should return [RestLocation] type', () async {
    expect(tLocationModel, isA<RestLocation>());
  });

  final tMap = jsonDecode(fixture('location.json')) as DataMap;

  group('fromMap', () {
    // test('should return a valid [RestLocation] from the map', () {
    //   //act
    //   final result = LocationModel.fromMap(tMap);
    //   //assert
    //   expect(result, isA<LocationModel>());
    //   expect(result, equals(tLocationModel));
    // });

    test('should throw an [Error] when the map os invalid', () {
      final map = DataMap.from(tMap)..remove('city');

      const call = LocationModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the LocationModel', () {
      final result = tLocationModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [LocationModel] with updated values', () {
      final result = tLocationModel.copyWith(city: 'Astana');

      expect(result.city, 'Astana');
    });
  });
}
