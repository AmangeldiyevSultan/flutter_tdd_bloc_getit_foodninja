import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/nav_bar.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/bloc/location/location_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationMapScreen extends StatefulWidget {
  const SetLocationMapScreen({super.key});

  static const String routeName = '/map-location';

  @override
  State<SetLocationMapScreen> createState() => _SetLocationMapScreenState();
}

class _SetLocationMapScreenState extends State<SetLocationMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.textFieldColour,
      ),
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
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    state.location!.latitude,
                    state.location!.longitude,
                  ),
                  zoom: 15,
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                SvgPicture.asset(
                  MediaRes.svgBackPattern,
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
