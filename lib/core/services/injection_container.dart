import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/use_cases/cache_first_timer.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/use_cases/check_if_user_first_timer.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/cubit/cubit/on_boarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  //Feature --> onBoarding
  //Business Logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(
        sl(),
      ),
    )
    ..registerLazySingleton(() => prefs);
}
