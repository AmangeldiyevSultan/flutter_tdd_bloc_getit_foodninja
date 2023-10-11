import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_in_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_logo.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _correctPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _correctPasswordController.dispose();
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
                  signText: 'Sign Up For Free',
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                SignUpForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  correctPasswordController: _correctPasswordController,
                  formKey: _formKey,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Create Account',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FirebaseAuth.instance.currentUser?.reload();
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      SignInScreen.routeName,
                    );
                  },
                  child: Text(
                    'already have an account?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colours.underLineColor,
                      fontSize: 12,
                      foreground: Paint()..shader = Colours.linearGradient,
                      fontFamily: Fonts.viga,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
