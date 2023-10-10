import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/repo/auth_repo.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(
    this._repo,
  );

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repo.updateUser(
        userData: params.userData,
        userAction: params.userAction,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.userAction,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : this(userAction: UpdateUserAction.firstName, userData: '');

  final UpdateUserAction userAction;
  final dynamic userData;

  @override
  List<dynamic> get props => [userAction, userAction];
}
