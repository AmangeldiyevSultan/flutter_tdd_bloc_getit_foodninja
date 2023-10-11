import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_social_media_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_logo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(MediaRes.backgroundPdf),
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                const SignLogo(
                  signText: 'Login To Your Account',
                ),
                SignInForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formKey: _formKey,
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                const Text(
                  'Or Continue With',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CtmSclMediaButton(
                      image: MediaRes.iconFacebook,
                      text: 'Facebook',
                      callback: () {},
                    ),
                    CtmSclMediaButton(
                      image: MediaRes.iconGoogle,
                      text: 'Google',
                      callback: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _textButton('Forgot Your Password?', () {}),
                _textButton('Create Account', () {
                  Navigator.pushReplacementNamed(
                    context,
                    SignUpScreen.routeName,
                  );
                }),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FirebaseAuth.instance.currentUser?.reload();
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _textButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 30,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colours.underLineColor,
            fontSize: 12,
            foreground: Paint()..shader = Colours.linearGradient,
            fontFamily: Fonts.viga,
          ),
        ),
      ),
    );
  }
}
