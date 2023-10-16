import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String password,
  });

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<void> updateUser({
    required dynamic userData,
    required UpdateUserAction userAction,
  });

  ResultFuture<LocalUser> googleSignIn();

  ResultFuture<LocalUser> facebookSignIn();
}
