import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword usecase;

  const tEmail = 'Test email';

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });

  test('should call the [AuthRepo.forgotPassword]', () async {
    // Arrange
    when(
      () => repo.forgotPassword(tEmail),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(tEmail); 

    expect(result, equals(const Right<dynamic, void>(null)));
  });
}
