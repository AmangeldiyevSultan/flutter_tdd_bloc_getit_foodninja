import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundColour,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Find Your\nFavorite Food',
                          style: TextStyle(fontSize: 31),
                        ),
                        SvgPicture.asset(MediaRes.svgIconNoNotification),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 18,
                          child: CustomTextField(
                            textColor: Colours.textDashColour,
                            isBorderShadow: false,
                            fillColor: Colours.textFieldColour,
                            controller: _searchController,
                            hintText: 'What do you want to order?',
                            hintColor: Colours.hintDashColour,
                            iconPrefixSourceWidget: Padding(
                              padding:
                                  const EdgeInsets.all(10).copyWith(left: 20),
                              child: SvgPicture.asset(MediaRes.svgIconSearch),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: context.height * 0.073,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colours.textFieldColour,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SvgPicture.asset(MediaRes.svgIconFilter),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Popular Restaurant',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        mainAxisExtent: context.height * 0.26,
                      ),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colours.shadowPurpleColour,
                                spreadRadius: 14,
                                blurRadius: 20,
                                offset: const Offset(4, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: context.width * 0.3,
                                height: context.height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Image.network(
                                  FirebaseAuth.instance.currentUser!.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                'Vegan Resto',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '12 min',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: Fonts.viga,
                                  fontWeight: FontWeight.w100,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
