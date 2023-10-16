import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/facebook_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late FacebookSignInMethod usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = FacebookSignInMethod(repo);
  });

  const tUser = LocalUser.empty();

  test('should call the [AuthRepo.facebookSignInMethod]', () async {
    // Arrange
    when(
      () => repo.facebookSignIn(),
    ).thenAnswer((_) async => const Right(tUser));

    // Act
    final result = await usecase();

    expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
  });
}
