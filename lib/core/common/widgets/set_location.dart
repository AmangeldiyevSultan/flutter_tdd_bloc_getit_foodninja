import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetLocation extends StatelessWidget {
  const SetLocation({
    required this.onTap,
    required this.textWidet,
    super.key,
  });

  final VoidCallback onTap;
  final Widget textWidet;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      shadowColor: Colours.shadowColour,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: SizedBox(
        height: context.height * 0.19,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg_img/logo-pin.svg',
                    semanticsLabel: 'My SVG Image',
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text('Your Location')
                ],
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.zero,
                  width: double.maxFinite,
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colours.setLocationBtnColour,
                  ),
                  child: Center(
                    child: textWidet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
