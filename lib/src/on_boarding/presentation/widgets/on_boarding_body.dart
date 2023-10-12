import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/domain/page_content.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:provider/provider.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    required this.pageContent,
    required this.pageController,
    super.key,
  });

  final PageContent pageContent;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * .5,
        ),
        SizedBox(
          height: context.height * .02,
        ),
        Padding(
          padding: const EdgeInsets.all(10).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: Fonts.bentonSans,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: context.height * .02,
        ),
        Text(
          pageContent.description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
        SizedBox(
          height: context.height * .05,
        ),
        CustomButton(
          child: Text(pageContent.buttonState),
          onPressed: () {
            pageContent.buttonState == 'Next'
                ? pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  )
                : context.read<OnBoardingCubit>().cacheFirstTimer();
          },
        ),
      ],
    );
  }
}
