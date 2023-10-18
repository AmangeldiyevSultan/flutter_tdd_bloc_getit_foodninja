import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/repo/auth_repo.dart';

class PostUserBio extends UsecaseWithParams<LocalUser, PostUserBioParams> {
  const PostUserBio(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call(PostUserBioParams params) => _repo.postUserBio(
        firstName: params.firstName,
        lastName: params.lastName,
        phoneNumber: params.phoneNumber,
      );
}

class PostUserBioParams extends Equatable {
  const PostUserBioParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  const PostUserBioParams.empty()
      : this(
          lastName: '',
          firstName: '',
          phoneNumber: '',
        );

  final String firstName;
  final String lastName;
  final String phoneNumber;

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber];
}
