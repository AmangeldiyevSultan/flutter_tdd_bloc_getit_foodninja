import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_icon_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyTemplate extends StatelessWidget {
  const BodyTemplate({
    required this.title,
    required this.onPressed,
    required this.buttonChild,
    required this.childs,
    this.subtitle,
    this.ctmIconBtnPress,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget buttonChild;
  final VoidCallback onPressed;
  final List<Widget> childs;
  final VoidCallback? ctmIconBtnPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: SvgPicture.asset(
              MediaRes.svgImageBackPattern,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconBtn(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    subtitle ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: Fonts.poppins,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ...childs,
                  const Spacer(),
                  Align(
                    child: CustomButton(
                      width: context.width * 0.53,
                      height: context.height * 0.067,
                      onPressed: onPressed,
                      child: buttonChild,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
