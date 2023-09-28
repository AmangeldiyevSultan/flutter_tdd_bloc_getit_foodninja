import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/repo/auth_repo.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(
    this._repo,
  );

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) =>
      _repo.signUp(email: params.email, password: params.password);
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
  });

  const SignUpParams.empty() : this(email: '', password: '');

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
