import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/choose_from_camera.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/choose_from_gallery.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/image_box.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/set_location_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePhotoScreen extends StatefulWidget {
  const UpdatePhotoScreen({super.key});
  static const String routeName = '/upload-photo-screen';

  @override
  State<UpdatePhotoScreen> createState() => _UpdatePhotoScreenState();
}

class _UpdatePhotoScreenState extends State<UpdatePhotoScreen> {
  File? _image;

  Future<void> _selectImage(ImageSource imageSource) async {
    final image = await CoreUtils.pickImageFrom(context, imageSource);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is UserUpdated) {
          Navigator.pushNamed(context, SetLocationScreen.routeName);
        }
      },
      builder: (context, state) {
        return SizedBox(
          child: BodyTemplate(
            subtitle: 'This data will be displayed in your account\n'
                'profile for security',
            title: 'Upload Your Photo\nProfile',
            onPressed: () async {
              unawaited(FirebaseAuth.instance.currentUser?.reload());
              if (_image == null) {
                await Navigator.pushNamed(context, SetLocationScreen.routeName);
              }
              if (context.mounted) {
                context.read<AuthBloc>().add(
                      UpdateUserEvent(
                        userAction: UpdateUserAction.profilePic,
                        userData: _image ??
                            await CoreUtils.getImageFileFromAssets(
                              'icons/person-logo.png',
                            ),
                      ),
                    );
              }
            },
            buttonChild: state is AuthLoading
                ? const Loading(
                    width: 20,
                    height: 20,
                  )
                : const Text('Next'),
            childs: [
              if (_image == null) ...[
                ChooseFromGallery(
                  onTap: () => _selectImage(ImageSource.gallery),
                ),
                const SizedBox(
                  height: 20,
                ),
                ChooseFromCamera(
                  onTap: () => _selectImage(ImageSource.camera),
                ),
              ],
              if (_image != null)
                ImageBox(
                  onPressedCloseIcon: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  image: _image,
                ),
            ],
          ),
        );
      },
    );
  }
}
