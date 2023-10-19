import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/post_user_bio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late PostUserBio usecase;

  const tFirstName = 'Test first name';
  const tLastName = 'Test last name';
  const tPhoneNumber = 'Test number';

  setUp(() {
    repo = MockAuthRepo();
    usecase = PostUserBio(repo);
  });

  const tUser = LocalUser.empty();

  test('should return [LocalUser] from the [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.postUserBio(
        firstName: tFirstName,
        lastName: tLastName,
        phoneNumber: tPhoneNumber,
      ),
    ).thenAnswer((_) async => const Right(tUser));

    //Act
    final result = await usecase(
      const PostUserBioParams(
        firstName: tFirstName,
        lastName: tLastName,
        phoneNumber: tPhoneNumber,
      ),
    );

    //Assert
    expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
  });
}
