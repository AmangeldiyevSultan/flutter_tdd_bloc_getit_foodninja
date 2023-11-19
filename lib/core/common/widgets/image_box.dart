import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({
    required this.onPressedCloseIcon,
    required this.image,
    super.key,
  });

  final File? image;
  final VoidCallback onPressedCloseIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colours.shadowColour,
                  blurRadius: 15,
                  spreadRadius: 6,
                  offset: Offset(7, 15),
                ),
              ],
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(image!),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9, top: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.4),
            child: IconButton(
              onPressed: onPressedCloseIcon,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
