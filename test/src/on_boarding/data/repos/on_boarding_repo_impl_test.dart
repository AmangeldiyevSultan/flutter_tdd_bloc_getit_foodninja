import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should  be a subclass of [onBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });

  group('cacheFirstTimer', () {
    test('should complete successfully when call to local source is successful',
        () async {
      when(() => localDataSource.cacheFirstTimer()).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repoImpl.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is '
        'unsuccsessful', () async {
      when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient storage', statusCode: 500),
      );

      final result = await repoImpl.cacheFirstTimer();

      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        ),
      );

      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('CheckIfUserFirstTimer', () {
    test('should complete successfully when call to local source is successful',
        () async {
      when(() => localDataSource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => false);

      final result = await repoImpl.checkIfUserIsFirstTimer();

      expect(result, equals(const Right<Failure, bool>(false)));

      verify(
        () => localDataSource.checkIfUserIsFirstTimer(),
      ).called(1);

      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is '
        'unsuccsessful', () async {
      when(
        () => localDataSource.checkIfUserIsFirstTimer(),
      ).thenThrow(      
        const CacheException(message: 'Insufficient storage', statusCode: 500),
      );

      final result = await repoImpl.checkIfUserIsFirstTimer();

      expect(
        result,
        equals( 
          Left<Failure, bool>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        ),
      ); 

      verify(() => localDataSource.checkIfUserIsFirstTimer(),).called(1);
      verifyNoMoreInteractions(localDataSource); 
    });
  });
}
