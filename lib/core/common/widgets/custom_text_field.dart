import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.iconPrefixSourceWidget,
    this.iconSuffixSource,
    this.textInputType,
    this.validator,
    this.overrideValidator = false,
    this.label,
    this.floatingLabelStyle,
    this.prefixWidget,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget? iconPrefixSourceWidget;
  final String? iconSuffixSource;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool overrideValidator;
  final Widget? label;
  final TextStyle? floatingLabelStyle;
  final Widget? prefixWidget;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;
  void _obscureTextButton() {
    obscureText = !obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colours.textFieldBorderColour,
            blurRadius: 15,
            spreadRadius: 6,
            offset: Offset(7, 15),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        validator: widget.overrideValidator
            ? widget.validator
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }

                return widget.validator?.call(value);
              },
        keyboardType: widget.textInputType,
        obscureText: obscureText,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        style: const TextStyle(
          fontFamily: Fonts.inter,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          prefix: widget.prefixWidget,
          floatingLabelStyle: widget.floatingLabelStyle,
          label: widget.label,
          prefixIcon: widget.iconPrefixSourceWidget,
          suffixIcon: widget.iconSuffixSource != null
              ? IconButton(
                  onPressed: _obscureTextButton,
                  icon: Image.asset(widget.iconSuffixSource!),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.width * 0.065,
            vertical: context.height * 0.025,
          ),
          hintStyle: const TextStyle(
            fontSize: 14,
            fontFamily: Fonts.poppins,
            fontWeight: FontWeight.w200,
            color: Colours.hintColour,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colours.textFieldBorderColour),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colours.textFieldBorderColour),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colours.textFieldBorderColour),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
