import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/svg.dart';

class SignLogo extends StatelessWidget {
  const SignLogo({required this.signText, super.key});

  final String signText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          width: 200,
          child: SvgPicture.asset(
            MediaRes.svgLogo,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        SvgPicture.asset(
          MediaRes.svgFoodNinjaName,
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
