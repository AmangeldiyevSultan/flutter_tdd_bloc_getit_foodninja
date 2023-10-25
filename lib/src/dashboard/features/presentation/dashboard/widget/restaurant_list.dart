import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/bloc/dashboard_bloc.dart';

class RestraurantListWidget extends StatelessWidget {
  const RestraurantListWidget({
    required this.state,
    super.key,
  });

  final FetchedRestaurants state;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: context.height * 0.26,
      ),
      itemCount: state.restaurants.length,
      itemBuilder: (BuildContext context, int restaurant) {
        final restaurantData = state.restaurants[restaurant];

        return Container(
          padding: const EdgeInsets.all(10),
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
                  restaurantData.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                restaurantData.name,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                restaurantData.description,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: Fonts.viga,
                  fontWeight: FontWeight.w100,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
