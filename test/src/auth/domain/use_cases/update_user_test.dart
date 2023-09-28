import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdatePassword usecase;

  const tUserData = 'Test userData';
  const tUserAction = UpdateUserAction.firstName;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdatePassword(repo);
  });

  test('should call the [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.updateUser(userData: tUserData, userAction: tUserAction),
    ).thenAnswer((_) async => const Right(null));

    //Act
    final result = await usecase(
      const UpdateUserParams(
        userAction: tUserAction,
        userData: tUserData, 
      ),
    );

    //Assert
    expect(result, equals(const Right<dynamic, void>(null)));
  });
}
