import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/page_under_construction.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/services/injection_container.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/bio_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/set_location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_in_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_success.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/upload_photo_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/views/dashboard.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    return const SignInScreen(); // or some other fallback
                  }
                  final localUser =
                      LocalUserModel.fromMap(snapshot.data!.data()!);

                  context.userProvider.initUser(localUser);

                  if (context.userProvider.user!.initialized!) {
                    return const DashBoard();
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
                            image: AssetImage(MediaRes.backgroundPdf2),
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
    case SetLocation.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SetLocation(),
        ),
        settings: settings,
      );
    case SignUpSuccess.routeName:
      return _pageBuilder(
        (_) => const SignUpSuccess(),
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
    case DashBoard.routeName:
      return _pageBuilder(
        (_) => const DashBoard(),
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
