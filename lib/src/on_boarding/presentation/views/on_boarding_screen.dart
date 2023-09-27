import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/page_content.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/cubit/cubit/on_boarding_cubit.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingStatus && state.isFirstTimer == false) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserCached) {
            // TODO(User-Cached-Handler): Push to the appropriate screen
          }
        },
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer ||
              state is CachingFirstTimer) {
            return const LoadingView();
          }
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(MediaRes.background),
                  ),
                ),
              ),
              PageView(
                controller: pageController,
                children: const [
                  OnBoardingBody(pageContent: PageContent.first()),
                  OnBoardingBody(pageContent: PageContent.second()),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
