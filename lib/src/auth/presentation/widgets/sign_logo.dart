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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          MediaRes.svgLogoName,
          fit: BoxFit.fitHeight,
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
