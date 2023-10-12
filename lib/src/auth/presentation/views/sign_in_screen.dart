import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/app/providers/user_provider.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_social_media_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_logo.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/views/dashboard.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is SignedIn) {
          context.read<UserProvider>().initUser(state.user as LocalUserModel);
          Navigator.pushReplacementNamed(context, DashBoard.routeName);
        }
      },
      builder: (context, state) {
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
                      height: context.height * 0.067,
                      width: context.width * 0.53,
                      child: state is AuthLoading
                          ? const Loading(
                              width: 20,
                              height: 20,
                            )
                          : const Text('Login'),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _textButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colours.underLineColor,
            fontSize: 15,
            color: Colours.underLineColor,
            fontFamily: Fonts.viga,
          ),
        ),
      ),
    );
  }
}
