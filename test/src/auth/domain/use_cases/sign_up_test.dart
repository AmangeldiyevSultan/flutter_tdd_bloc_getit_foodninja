import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  test('should call the [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.signUp(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Right(null));

    //Act
    final result =
        await usecase(const SignUpParams(email: tEmail, password: tPassword));

    //Assert
    expect(result, equals( const Right<dynamic, void>(null)));
  });
}
