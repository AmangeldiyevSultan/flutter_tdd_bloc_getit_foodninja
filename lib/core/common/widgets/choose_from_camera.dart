import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class ChooseFromCamera extends StatelessWidget {
  const ChooseFromCamera({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

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
        child: GestureDetector(
          onTap: onTap,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image(
                  image: AssetImage(MediaRes.iconCamera),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('From Camera')
            ],
          ),
        ),
      ),
    );
  }
}
