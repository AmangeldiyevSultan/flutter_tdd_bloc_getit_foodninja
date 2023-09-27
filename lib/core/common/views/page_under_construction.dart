import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MediaRes.background),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Lottie.asset(MediaRes.underContruction),
          ),
        ),
      ),
    );
  }
}
