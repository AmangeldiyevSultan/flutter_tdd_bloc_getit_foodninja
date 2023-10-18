import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_in_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/bio_form.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  static const String routeName = '/bio-screen';

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNumer = TextEditingController();

  late Country country;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BodyTemplate(
          title: 'Fill in your io to get\n started',
          subtitle: 'This data will be displayed in your'
              ' accound profile for security',
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
          },
          childs: [
            BioForm(
              formKey: _formKey,
              lastName: _lastName,
              firstName: _firstName,
              phoneNumber: _phoneNumer,
            ),
          ],
          buttonChild: state is AuthLoading
              ? const Loading(
                  width: 20,
                  height: 20,
                )
              : const Text('Next'),
          ctmIconBtnPress: () {
            Navigator.pushReplacementNamed(context, SignInScreen.routeName);
          },
        );
      },
    );
  }
}
