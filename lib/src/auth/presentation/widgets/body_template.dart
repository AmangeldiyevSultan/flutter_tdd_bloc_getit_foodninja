import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_icon_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class BodyTemplate extends StatelessWidget {
  const BodyTemplate({
    required this.title,
    required this.onPressed,
    required this.child,
    required this.childs,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onPressed;
  final List<Widget> childs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MediaRes.backgroundPdf2),
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CustomIconBtn(),
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
                ],
              ),
              CustomButton(
                width: context.width * 0.53,
                height: context.height * 0.067,
                onPressed: onPressed,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
