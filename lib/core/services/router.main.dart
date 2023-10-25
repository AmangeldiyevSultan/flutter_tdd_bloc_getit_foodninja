part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;

            return FutureBuilder(
              future: sl<FirebaseFirestore>()
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SignInScreen();
                  }
                  final localUser =
                      LocalUserModel.fromMap(snapshot.data!.data()!);

                  context.userProvider.initUser(localUser);

                  if (context.userProvider.user!.initialized!) {
                    return const NavBar();
                  } else {
                    return BlocProvider(
                      create: (_) => sl<AuthBloc>(),
                      child: const BioScreen(),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                    body: SafeArea(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(MediaRes.imageBackground),
                          ),
                        ),
                        child: const LoadingView(),
                      ),
                    ),
                  );
                } else {
                  return const SignInScreen();
                }
              },
            );
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );

    case NavBar.routeName:
      return _pageBuilder(
        (_) => const NavBar(),
        settings: settings,
      );
    case SetLocationMapScreen.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<LocationBloc>()..add(const LoadMapEvent()),
            ),
            BlocProvider(
              create: (_) => sl<AutocompleteBloc>(),
            ),
          ],
          child: const SetLocationMapScreen(),
        ),
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case UpdatePhotoScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const UpdatePhotoScreen(),
        ),
        settings: settings,
      );
    case SetLocationScreen.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<DashboardBloc>(),
            )
          ],
          child: const SetLocationScreen(),
        ),
        settings: settings,
      );
    case SignUpSuccessScreen.routeName:
      return _pageBuilder(
        (_) => const SignUpSuccessScreen(),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case ForgotPasswordScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
        settings: settings,
      );

    case BioScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const BioScreen(),
        ),
        settings: settings,
      );
    case DashBoardScreen.routeName:
      return _pageBuilder(
        (_) => const DashBoardScreen(),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
