import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CheckIfUserIsFirstTimer extends UsecaseWithoutParams<bool>{
  const CheckIfUserIsFirstTimer(this._repo);

  final OnBoardingRepo _repo;
 
  @override
  ResultFuture<bool> call() async => _repo.checkIfUserIsFirstTimer();
}
