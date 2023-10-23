import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/views/set_location_map_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({super.key});

  @override
  State<CreateRestaurantScreen> createState() => _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen> {
  final _restName = TextEditingController();
  final _restDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
  void dispose() {
    super.dispose();
    _restName.dispose();
    _restDescription.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            MediaRes.svgBackNavPattern,
            width: context.width,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Create Restaurant',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _restName,
                            hintText: 'Restaurant Name',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controller: _restDescription,
                            hintText: 'Restaurant Description',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_image == null) _chooseRestaurantLogo(context),
                    if (_image != null) _restaurantLogo(),
                    const SizedBox(
                      height: 20,
                    ),
                    _setLocation(context),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      child: const Text('Create'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card _setLocation(BuildContext context) {
    return Card(
      elevation: 0.4,
      shadowColor: Colours.shadowColour,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: SizedBox(
        height: context.height * 0.19,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg_img/logo-pin.svg',
                    semanticsLabel: 'My SVG Image',
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text('Your Location')
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SetLocationMapScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.zero,
                  width: double.maxFinite,
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colours.setLocationBtnColour,
                  ),
                  child: const Center(child: Text('Set Location')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _chooseRestaurantLogo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colours.textFieldBorderColour,
            blurRadius: 15,
            spreadRadius: 6,
            offset: Offset(7, 15),
          ),
        ],
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
    );
  }

  Stack _restaurantLogo() {
    return Stack(
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
    );
  }
}
