import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/set_location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/exports/blocs.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_success_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/location_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/views/set_location_map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});
  static const String routeName = '/set-location';

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  DataMap? _position;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashBoardError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return BodyTemplate(
          title: 'Set Your Location',
          subtitle: 'This data will be displayed in your account\n'
              'profile for security',
          onPressed: () {
            LocationModel? locationInfo;
            if (_position != null) {
              final latLng = _position!['position'] as LatLng;
              final country = _position!['country'] as String?;
              final city = _position!['city'] as String?;
              locationInfo = LocationModel(
                country: country ?? '',
                city: city ?? '',
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              );
              context.read<AuthBloc>().add(
                    UpdateUserEvent(
                      userAction: UpdateUserAction.location,
                      userData: locationInfo,
                    ),
                  );
            }

            Navigator.restorablePushNamedAndRemoveUntil(
              context,
              SignUpSuccessScreen.routeName,
              (route) => false,
            );
          },
          buttonChild: state is AuthLoading
              ? const Loading(
                  width: 20,
                  height: 20,
                )
              : const Text('Next'),
          childs: [
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
          ],
        );
      },
    );
  }
}
