import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_svg/svg.dart';

class CtmSclMediaButton extends StatelessWidget {
  const CtmSclMediaButton({
    required this.image,
    required this.text,
    required this.callback,
    super.key,
  });

  final String text;
  final String image;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.08,
      width: context.width * 0.40,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colours.textFieldBorderColour,
            blurRadius: 15,
            spreadRadius: 7,
            offset: Offset(7, 15),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.withOpacity(0.8),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
            side: const BorderSide(
              color: Colours.textFieldBorderColour,
            ),
          ),
        ),
        onPressed: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(image),
            Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
