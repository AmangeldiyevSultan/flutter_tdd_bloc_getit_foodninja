import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/nav_bar.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_button.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/bloc/autocomplete/autocomplete_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/bloc/location/location_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/widgets/search_box_suggestions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationMapScreen extends StatefulWidget {
  const SetLocationMapScreen({super.key});

  static const String routeName = '/map-location';

  @override
  State<SetLocationMapScreen> createState() => _SetLocationMapScreenState();
}

class _SetLocationMapScreenState extends State<SetLocationMapScreen> {
  bool obscureText = false;
  void obscureTextButton() {
    obscureText = !obscureText;
    setState(() {});
  }

  final _searchController = TextEditingController();
  final List<Marker> marker = [];

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            CoreUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const LoadingView();
          }
          if (state is LocationLoaded) {
            return SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        state.place.latitude,
                        state.place.longitude,
                      ),
                      zoom: 17,
                    ),
                    onMapCreated: (controller) {
                      context.read<LocationBloc>().add(
                            LoadMapEvent(
                              controller: controller,
                            ),
                          );
                    },
                    markers: marker.map((marker) => marker).toSet(),
                    onTap: (position) {
                      final newMarker = Marker(
                        markerId: const MarkerId(
                          'marker',
                        ),
                        position: LatLng(position.latitude, position.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                      );
                      marker.add(newMarker);

                      context.read<LocationBloc>().add(
                            LatLngMapEvent(
                              latLng: position,
                            ),
                          );

                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20,
                                      spreadRadius: 20,
                                      color: Colours.shadowPurpleColour,
                                    ),
                                  ],
                                ),
                                child: CustomTextField(
                                  onChange: (searchInput) {
                                    context.read<AutocompleteBloc>().add(
                                          LoadAutocompleteEvent(
                                            searchInput: searchInput,
                                          ),
                                        );
                                    return null;
                                  },
                                  textColor: Colours.textDashColour,
                                  isBorderShadow: false,
                                  fillColor: Colors.white,
                                  controller: _searchController,
                                  hintText: 'What place do you looking for?',
                                  hintColor: Colours.hintDashColour,
                                  iconPrefixSourceWidget: Padding(
                                    padding: const EdgeInsets.all(10)
                                        .copyWith(left: 20),
                                    child: SvgPicture.asset(
                                      MediaRes.svgIconSearch,
                                    ),
                                  ),
                                  obscureText: obscureText,
                                  iconSuffixSourceWidget: IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      context.read<AutocompleteBloc>().add(
                                            ClearAutocompleteEvent(),
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colours.arrowBackColour,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 10,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: IconButton(
                                splashRadius: 15,
                                color: Colours.arrowBackColour,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 20,
                                        spreadRadius: 20,
                                        color: Colours.shadowPurpleColour,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (FocusScope.of(context).hasFocus ||
                            _searchController.text.isNotEmpty)
                          BlocListener<AutocompleteBloc, AutocompleteState>(
                            listener: (context, state) {
                              if (state is AutocompleteCleared) {
                                setState(() {});
                              }
                            },
                            child: Expanded(
                              child: SearchBoxSuggestions(
                                searchController: _searchController,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.only(bottom: marker.isEmpty ? 0 : 20),
                      child: CustomButton(
                        width: marker.isEmpty ? 0 : null,
                        height: marker.isEmpty ? 0 : null,
                        child: const Text(
                          'Set Position',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            'position': marker.first.position,
                            'country': state.place.country,
                            'city': state.place.city,
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                SvgPicture.asset(
                  MediaRes.svgImageBackPattern,
                  width: double.maxFinite,
                  alignment: Alignment.topCenter,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Somthing went wrong, Try later!'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            NavBar.routeName,
                            (route) => false,
                          );
                        },
                        child: const Text('Go Back!'),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
