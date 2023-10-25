import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class ChooseFromGallery extends StatelessWidget {
  const ChooseFromGallery({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colours.textFieldBorderColour,
            blurRadius: 15,
            spreadRadius: 6,
            offset: Offset(7, 15),
          ),
        ],
      ),
      child: SizedBox(
        height: context.height * 0.19,
        width: double.maxFinite,
        child: GestureDetector(
          onTap: onTap,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image(
                  image: AssetImage(MediaRes.iconGallery),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('From Gallery')
            ],
          ),
        ),
      ),
    );
  }
}
