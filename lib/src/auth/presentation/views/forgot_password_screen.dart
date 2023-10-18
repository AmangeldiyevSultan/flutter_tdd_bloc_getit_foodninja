import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';

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
          CoreUtils.showSnackBar(context, 'Successfully Send to your Email  ');
        }
      },
      builder: (context, state) {
        return BodyTemplate(
          title: 'Forgot Password?',
          subtitle: 'Use to reset your password',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            FirebaseAuth.instance.currentUser?.reload();

            if (_formKey.currentState!.validate()) {
              context.read<AuthBloc>().add(
                    ForgotPasswordEvent(_emailController.text.trim()),
                  );
            }
          },
          childs: [
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
                floatingLabelStyle: const TextStyle(color: Colours.labelColour),
                iconPrefixSourceWidget: Image.asset(MediaRes.vectorMessage),
                controller: _emailController,
                hintText: 'Email',
                validator: (String? value) =>
                    value!.isValidEmail() ? null : 'Invalid email',
              ),
            ),
          ],
          buttonChild: state is AuthLoading
              ? const Loading(
                  width: 20,
                  height: 20,
                )
              : const Text('Send'),
        );
      },
    );
  }
}
