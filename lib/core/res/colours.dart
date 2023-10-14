import 'package:flutter/material.dart';

class Colours {
  const Colours._();

  static const LinearGradient gradientButton = LinearGradient(
    colors: [
      Color(0xff53E88B),
      Color(0xff15BE77),
    ],
  );

  static Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xff53E88B), Color(0xff15BE77)],
  ).createShader(const Rect.fromLTWH(0, 0, 200, 70));

  static const underLineColor = Color(0xff53E88B);
  static const snackBarColours = Color(0xff15BE77);
  static const hintColour = Color(0xff3B3B3B);
  static const textFieldBorderColour = Color(0xffF4F4F4);
  static const shadowColour = Color(0xffF4F4F4);
  static const arrowBackColour = Color(0xffDA6317);
  static const lightAmberColour = Color(0xffF9A84D);
  static const labelColour = Color(0xff828282);
}
