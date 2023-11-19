// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/svg.dart';

class SignUpForm extends StatefulWidget {
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
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscureText = false;
  void _obscureTextButton() {
    obscureText = !obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            textInputType: TextInputType.emailAddress,
            iconPrefixSourceWidget: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: SvgPicture.asset(
                MediaRes.svgIconMessage,
                height: 40,
              ),
            ),
            controller: widget.emailController,
            hintText: 'Email',
            validator: (String? value) =>
                value!.isValidEmail() ? null : 'Invalid email',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            iconPrefixSourceWidget: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: SvgPicture.asset(
                MediaRes.svgIconLock,
                height: 40,
              ),
            ),
            obscureText: obscureText,
            iconSuffixSourceWidget: IconButton(
              onPressed: _obscureTextButton,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_sharp
                    : Icons.visibility_sharp,
                color: Colors.grey,
              ),
            ),
            controller: widget.passwordController,
            hintText: 'Password',
            validator: (value) =>
                value!.length < 6 ? 'Should be more than 6 characters' : null,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            iconPrefixSourceWidget: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: SvgPicture.asset(
                MediaRes.svgIconLock,
                height: 40,
              ),
            ),
            obscureText: obscureText,
            iconSuffixSourceWidget: IconButton(
              onPressed: _obscureTextButton,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_sharp
                    : Icons.visibility_sharp,
                color: Colors.grey,
              ),
            ),
            controller: widget.correctPasswordController,
            hintText: 'Confirm Password',
            validator: (value) => value != widget.passwordController.text
                ? 'Passwords do not match'
                : null,
          ),
        ],
      ),
    );
  }
}
