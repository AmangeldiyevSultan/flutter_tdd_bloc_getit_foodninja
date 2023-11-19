import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colours.textFieldColour,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '1 Km',
                style: TextStyle(
                  color: Colours.textDashColour,
                  fontFamily: Fonts.inter,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colours.textFieldColour,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '> 10 Km',
                style: TextStyle(
                  color: Colours.textDashColour,
                  fontFamily: Fonts.inter,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
