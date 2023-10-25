import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/choose_from_gallery.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/image_box.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/set_location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/exports/blocs.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/bloc/dashboard_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/presentation/admin_panel/widgets/create_restaurants_header.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/views/set_location_map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  DataMap? _position;

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
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashBoardError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CreateHeader(
          column: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Create Your Own Restaurant',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
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
              if (_image == null)
                ChooseFromGallery(
                  onTap: () => _selectImage(ImageSource.gallery),
                ),
              if (_image != null)
                ImageBox(
                  onPressedCloseIcon: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  image: _image,
                ),
              const SizedBox(
                height: 20,
              ),
              SetLocation(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    SetLocationMapScreen.routeName,
                  ).then((value) {
                    setState(() {
                      _position = value as DataMap?;
                    });
                  });
                },
                textWidet: Text(
                  _position == null ? 'Set Location' : 'Your Location Saved',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                child: state is DashBoardLoading
                    ? const Loading(
                        width: 20,
                        height: 20,
                      )
                    : const Text('Create'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_image == null || _position == null) {
                      CoreUtils.showSnackBar(
                        context,
                        'Upload Image and Set Location!',
                      );
                    } else {
                      final latLng = _position!['position'] as LatLng;
                      final country = _position!['country'] as String?;
                      final city = _position!['city'] as String?;
                      final locationInfo = RestLocation(
                        country: country ?? '',
                        city: city ?? '',
                        latitude: latLng.latitude,
                        longitude: latLng.longitude,
                      );

                      context.read<DashboardBloc>().add(
                            CreateRestaurantEvent(
                              name: _restName.text.trim(),
                              description: _restDescription.text.trim(),
                              image: _image!,
                              location: locationInfo,
                            ),
                          );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
