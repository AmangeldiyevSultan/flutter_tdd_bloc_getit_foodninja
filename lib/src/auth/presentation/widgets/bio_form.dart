import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/typdef_extenstion.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';

class BioForm extends StatelessWidget {
  const BioForm({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.formKey,
    super.key,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController phoneNumber;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            textInputType: TextInputType.name,
            controller: firstName,
            hintText: 'Name',
            overrideValidator: true,
            // validator: (String? value) => value!.length > 2
            //     ? null
            //     : 'Name should contain at least 3 characters',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            textInputType: TextInputType.name,
            controller: lastName,
            overrideValidator: true,
            hintText: 'Surname',
            // validator: (String? value) => value!.length < 2
            //     ? 'Surname should contain at least 3 characters'
            //     : null,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            iconPrefixSourceWidget: const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                '+  ',
                style: TextStyle(
                  fontFamily: Fonts.poppins,
                  fontSize: 16,
                  color: Colours.hintColour,
                ),
              ),
            ),
            textInputType: TextInputType.phone,
            controller: phoneNumber,
            hintText: 'Phone Number',
            overrideValidator: true,
            validator: (String? value) => value == null || value.trim() == ''
                ? null
                : value.isValidPhoneNumber()
                    ? null
                    : 'Please enter valid mobile number',
          )
        ],
      ),
    );
  }
}
