import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            textInputType: TextInputType.emailAddress,
            controller: emailController,
            hintText: 'Email',
            validator: (String? value) =>
                value!.isValidEmail() ? null : 'Invalid email',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            validator: (value) =>
                value!.length > 6 ? 'Should be more than 6 characters' : null,
          )
        ],
      ),
    );
  }
}
