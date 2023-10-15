import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';

class CustomIconBtn extends StatelessWidget {
  const CustomIconBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 15,
      color: Colours.arrowBackColour,
      iconSize: 20,
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colours.lightAmberColour.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}
