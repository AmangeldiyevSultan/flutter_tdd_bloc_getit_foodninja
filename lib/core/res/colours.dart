import 'package:flutter/material.dart';

class Colours {
  const Colours._();

  static const LinearGradient gradientButton = LinearGradient(
    colors: [
      Color(0xff53E88B),
      Color(0xff15BE77),
    ],
  );

  static final LinearGradient gradientNavBar = LinearGradient(
    colors: [
      const Color(0xff53E88B).withOpacity(0.3),
      const Color(0xff15BE77).withOpacity(0.3),
    ],
  );

  static Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xff53E88B), Color(0xff15BE77)],
  ).createShader(const Rect.fromLTWH(0, 0, 200, 70));

  static const underLineColor = Color(0xff53E88B);
  static const snackBarColours = Color(0xff15BE77);
  static const textFieldBorderColour = Color(0xffF4F4F4);
  static const shadowColour = Color(0xffF4F4F4);
  static const arrowBackColour = Color(0xffDA6317);
  static const lightAmberColour = Color(0xffF9A84D);
  static const labelColour = Color(0xff828282);
  static const setLocationBtnColour = Color(0xffF6F6F6);
  static const backgroundColour = Color(0xffFEFEFF);
  static const textDashColour = Color(0xffDA6317);

  static Color shadowPurpleColour = const Color(0xff5A6CEA).withOpacity(0.04);
  static Color hintColour = const Color(0xff3B3B3B).withOpacity(0.4);
  static Color textFieldColour = const Color(0xffF9A84D).withOpacity(0.1);
  static Color hintDashColour = const Color(0xffDA6317).withOpacity(0.3);
}
