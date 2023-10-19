import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/app/providers/user_provider.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_in_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/upload_photo_screen.dart';
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
      listener: (context, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is UserBioPosted) {
          context.read<UserProvider>().user = state.user as LocalUserModel;

          Navigator.pushNamed(context, UpdatePhotoScreen.routeName);
        }
      },
      builder: (context, state) {
        return BodyTemplate(
          title: 'Fill in your in to get\nstarted',
          subtitle: 'This data will be displayed in your'
              ' accound profile for security',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              FocusManager.instance.primaryFocus?.unfocus();
              FirebaseAuth.instance.currentUser?.reload();
              context.read<AuthBloc>().add(
                    UserPostBioEvent(
                      firstName: _firstName.text.trim(),
                      lastName: _lastName.text.trim(),
                      phoneNumber: _phoneNumer.text.trim().isNotEmpty
                          ? '+${_phoneNumer.text.trim()}'
                          : _phoneNumer.text.trim(),
                    ),
                  );
            }
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
