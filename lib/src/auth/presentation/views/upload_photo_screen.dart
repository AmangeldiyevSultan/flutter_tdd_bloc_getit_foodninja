import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
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
              context.read<AuthBloc>().add(
                    UpdateUserEvent(
                      userAction: UpdateUserAction.profilePic,
                      userData: _image ??
                          await CoreUtils.getImageFileFromAssets(
                            'icons/person-logo.png',
                          ),
                    ),
                  );
            },
            buttonChild: state is AuthLoading
                ? const Loading(
                    width: 20,
                    height: 20,
                  )
                : const Text('Next'),
            childs: [
              if (_image == null) ...[
                Card(
                  elevation: 0.4,
                  shadowColor: Colours.shadowColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: SizedBox(
                    height: context.height * 0.19,
                    width: double.maxFinite,
                    child: GestureDetector(
                      onTap: () => _selectImage(ImageSource.gallery),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage(MediaRes.iconGallery),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('From Gallery')
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0.4,
                  shadowColor: Colours.shadowColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: SizedBox(
                    height: context.height * 0.19,
                    width: double.maxFinite,
                    child: GestureDetector(
                      onTap: () => _selectImage(ImageSource.camera),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage(MediaRes.iconCamera),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('From Camera')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (_image != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colours.shadowColour,
                              blurRadius: 15,
                              spreadRadius: 6,
                              offset: Offset(7, 15),
                            )
                          ],
                          borderRadius: BorderRadius.circular(22),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 9, top: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.4),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
