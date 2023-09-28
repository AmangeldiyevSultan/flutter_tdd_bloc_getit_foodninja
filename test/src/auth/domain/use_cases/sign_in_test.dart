import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignIn usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });

  const tUser = LocalUser.empty();

  test('should return [LocalUser] from the [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.signIn(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Right(tUser));

    //Act
    final result =
        await usecase(const SignInParams(email: tEmail, password: tPassword));

    //Assert
    expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
  });
}
