import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/app/providers/user_provider.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/bio_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_in_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_logo.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/views/dashboard.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is SignedUp) {
          context.read<AuthBloc>().add(
                SignInEvent(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                ),
              );
        } else if (state is SignedIn) {
          context.read<UserProvider>().initUser(state.user as LocalUserModel);
          context.userProvider.user!.initialized ??
              Navigator.pushReplacementNamed(context, BioScreen.routeName);
          context.userProvider.user!.initialized!
              ? Navigator.pushReplacementNamed(context, DashBoard.routeName)
              : Navigator.pushReplacementNamed(context, BioScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      MediaRes.backgroundPdf,
                    ),
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: state is AuthLoading
                            ? const Loading(
                                width: 20,
                                height: 20,
                              )
                            : const Text('Create Account'),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text(
                          'already have an account?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colours.underLineColor,
                            fontSize: 12,
                            color: Colours.underLineColor,
                            fontFamily: Fonts.viga,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
