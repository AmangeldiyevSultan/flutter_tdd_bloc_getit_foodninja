import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateHeader extends StatelessWidget {
  const CreateHeader({
    required this.column,
    super.key,
  });

  final Column column;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            MediaRes.svgImageBackNavPattern,
            width: context.width,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: column,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
