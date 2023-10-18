// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.correctPasswordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController correctPasswordController;
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
            iconPrefixSourceWidget: Image.asset(MediaRes.iconMessage),
            controller: emailController,
            hintText: 'Email',
            validator: (String? value) =>
                value!.isValidEmail() ? null : 'Invalid email',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            iconPrefixSourceWidget: Image.asset(MediaRes.iconLock),
            iconSuffixSource: MediaRes.iconShow,
            controller: passwordController,
            hintText: 'Password',
            validator: (value) =>
                value!.length < 6 ? 'Should be more than 6 characters' : null,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            iconPrefixSourceWidget: Image.asset(MediaRes.iconLock),
            iconSuffixSource: MediaRes.iconShow,
            controller: correctPasswordController,
            hintText: 'Confirm Password',
            validator: (value) => value != passwordController.text
                ? 'Passwords do not match'
                : null,
          )
        ],
      ),
    );
  }
}
