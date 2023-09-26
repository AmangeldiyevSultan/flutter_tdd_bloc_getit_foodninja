import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/use_cases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usercase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usercase = CacheFirstTimer(repo);
  });

  test(
      'should call the [onBoardingRepo.cacheFirstTimer] '
      'and return the right data', () async {
    when(() => repo.cacheFirstTimer()).thenAnswer(
      (_) async => Left(
        ServerFailure(
          message: 'Unknown Error Occured',
          statusCode: 500,
        ),
      ),
    );

    final result = await usercase();

    expect( 
      result,
      equals(
        Left<Failure, dynamic>(
          ServerFailure(message: 'Unknown Error Occured', statusCode: 500),
        ),
      ),
    );

    verify(() => repo.cacheFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
