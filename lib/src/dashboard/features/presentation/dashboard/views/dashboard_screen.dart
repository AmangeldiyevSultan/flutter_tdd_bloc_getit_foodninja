import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/custom_text_field.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/widgets/loading_state.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/exports/blocs.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/utils.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/presentation/dashboard/widget/filter.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/presentation/dashboard/widget/restaurant_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _searchController = TextEditingController();
  bool isFilterOpened = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
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
        if (state is FetchedRestaurants) {
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
                                    padding: const EdgeInsets.all(10)
                                        .copyWith(left: 20),
                                    child: SvgPicture.asset(
                                      MediaRes.svgIconSearch,
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
                                flex: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    isFilterOpened = !isFilterOpened;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: context.height * 0.073,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colours.textFieldColour,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: SvgPicture.asset(
                                      MediaRes.svgIconFilter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const FilterWidget(),
                          const Text(
                            'Popular Restaurant',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RestraurantListWidget(state: state),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Loading();
      },
    );
  }
}
