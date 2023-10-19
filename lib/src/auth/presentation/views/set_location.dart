import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/views/sign_up_success.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';
import 'package:flutter_svg/svg.dart';

class SetLocation extends StatelessWidget {
  const SetLocation({super.key});
  static const String routeName = '/set-location';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BodyTemplate(
          title: 'Set Your Location',
          subtitle: 'This data will be displayed in your account\n'
              'profile for security',
          onPressed: () {
            Navigator.restorablePushNamedAndRemoveUntil(
              context,
              SignUpSuccess.routeName,
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
            Card(
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
                        onTap: () {},
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
            ),
          ],
        );
      },
    );
  }
}
