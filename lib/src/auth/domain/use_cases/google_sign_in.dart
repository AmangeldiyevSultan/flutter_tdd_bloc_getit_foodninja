import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/repo/auth_repo.dart';

class GoogleSignInMethod extends UsecaseWithoutParams<LocalUser> {
  const GoogleSignInMethod(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call() => _repo.googleSignIn();
}
