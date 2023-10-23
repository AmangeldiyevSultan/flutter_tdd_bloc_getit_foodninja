part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
  await _initRestaurants();
}

Future<void> _initOnBoarding() async {
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

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
        googleSignInMethod: sl(),
        facebookSignInMethod: sl(),
        postUserBio: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => GoogleSignInMethod(sl()))
    ..registerLazySingleton(() => FacebookSignInMethod(sl()))
    ..registerLazySingleton(() => PostUserBio(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
        googleAuthClient: sl(),
        facebookAuth: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(GoogleSignIn.new)
    ..registerLazySingleton(() => FacebookAuth.instance);
}

Future<void> _initRestaurants() async {
  sl
    ..registerFactory(
      () => DashboardBloc(
        createRestaurant: sl(),
        fetchRestaurants: sl(),
      ),
    )
    ..registerFactory(() => LocationBloc(geoLocation: sl()))
    ..registerFactory(() => AutocompleteBloc(getAutocomplete: sl()))
    ..registerLazySingleton(() => CreateRestaurant(sl()))
    ..registerLazySingleton(() => FetchRestaurants(sl()))
    ..registerLazySingleton(() => GetLocation(sl()))
    ..registerLazySingleton(() => GetAutocomplete(sl()))
    ..registerLazySingleton<RestaurantRepo>(() => RestaurantRepoImpl(sl()))
    ..registerLazySingleton<LocationRepo>(() => LocationRepoImpl(sl()))
    ..registerLazySingleton<RestRemoteDataSource>(
      () => RestRemoteDataSourceImpl(
        cloudStoreClient: sl(),
      ),
    )
    ..registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton(
      http.Client.new,
    );
}
