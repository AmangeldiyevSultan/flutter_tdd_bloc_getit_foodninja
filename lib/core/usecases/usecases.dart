import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();
  
  ResultFuture<Type> call (Params params);
}

abstract class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();

  ResultFuture<Type> call(); 
}
