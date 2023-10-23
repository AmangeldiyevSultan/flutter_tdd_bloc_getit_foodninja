import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/nav_bar.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/svg.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  static const String routeName = '/sign-up-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.maxFinite,
              height: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      child: const Text('Try Order'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          NavBar.routeName,
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(MediaRes.svgLogoSuccess),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Congrats!',
                        style: TextStyle(
                          color: Colours.underLineColor,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Your Profile Ready To Use!',
                        style: TextStyle(fontSize: 23),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: SvgPicture.asset(
              MediaRes.svgImageBackPattern,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
