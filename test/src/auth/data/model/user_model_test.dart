import 'dart:convert';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture/fixture_reader.dart';

class MockLocalUser extends Mock implements LocalUser {}

void main() {
  late LocalUserModel tLocalUserModel;
  setUp(() {
    tLocalUserModel = const LocalUserModel.empty();
  });
  test('should return [LocalUser] type', () async {
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      //act
      final result = LocalUserModel.fromMap(tMap);
      //assert
      expect(result, isA<LocalUserModel>());
      expect(result, equals(tLocalUserModel));
    });

    test('should throw an [Error] when the map os invalid', () {
      final map = DataMap.from(tMap)..remove('uid');

      const call = LocalUserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the LocalUserModel', () {
      final result = tLocalUserModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () { 
    test('should return a valid [LocalUserModel] with updated values', (){
      final result = tLocalUserModel.copyWith(uid: '2');

      expect(result.uid, '2');
    });
  });
}
