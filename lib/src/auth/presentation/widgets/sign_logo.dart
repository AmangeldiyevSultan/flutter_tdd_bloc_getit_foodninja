import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class SignLogo extends StatelessWidget {
  const SignLogo({required this.signText, super.key});

  final String signText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(MediaRes.logo),
        SizedBox(
          height: context.height * 0.001,
        ),
        Text(
          'FoodNinja',
          style: TextStyle(
            fontSize: 40,
            foreground: Paint()..shader = Colours.linearGradient,
            fontFamily: Fonts.viga,
          ),
        ),
        const Text(
          'Deliever Favorite Food',
          style: TextStyle(
            fontSize: 13,
            fontFamily: Fonts.inter,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          signText,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: context.height * 0.045,
        ),
      ],
    );
  }
}
