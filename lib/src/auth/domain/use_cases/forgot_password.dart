import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/repo/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String>{
  const ForgotPassword(this._repo);

 final AuthRepo _repo;

  @override 
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
