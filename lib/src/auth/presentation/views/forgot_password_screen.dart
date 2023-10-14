import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_icon_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is ForgotPasswordSent) {
          CoreUtils.showSnackBar(context, 'Successfully Send to your Email');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: context.width,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MediaRes.backgroundPdf2),
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomIconBtn(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Use to reset your password',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: Fonts.poppins,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: CustomTextField(
                          textInputType: TextInputType.emailAddress,
                          label: const Text(
                            'Via email:',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: Fonts.poppins,
                            ),
                          ),
                          floatingLabelStyle:
                              const TextStyle(color: Colours.labelColour),
                          iconPrefixSource: MediaRes.vectorMessage,
                          controller: _emailController,
                          hintText: 'Email',
                          validator: (String? value) =>
                              value!.isValidEmail() ? null : 'Invalid email',
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    width: context.width * 0.53,
                    height: context.height * 0.067,
                    child: state is AuthLoading
                        ? const Loading(
                            width: 20,
                            height: 20,
                          )
                        : const Text('Send'),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      FirebaseAuth.instance.currentUser?.reload();

                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              ForgotPasswordEvent(_emailController.text.trim()),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
