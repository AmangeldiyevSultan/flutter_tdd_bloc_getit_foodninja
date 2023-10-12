import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({this.height, this.width, super.key});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
