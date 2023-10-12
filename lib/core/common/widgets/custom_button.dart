import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    super.key,
  });

  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: Colours.gradientButton,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.21,
            vertical: context.height * 0.02,
          ),
          foregroundColor: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
