// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.latitude,
    required super.longitude,
    super.placeId,
    super.name,
    super.city,
    super.country,
  });

  const PlaceModel.empty()
      : this(
          placeId: '',
          name: '',
          city: '',
          country: '',
          latitude: 0,
          longitude: 0,
        );

  factory PlaceModel.fromMap(DataMap map) {
    final addressComponents = map['address_components'] as List<dynamic>;
    String? country;
    String? city;

    for (final component in addressComponents) {
      if (component['types'] != null && component['types'][0] == 'country') {
        country = component['long_name'] as String?;
      } else if (component['types'] != null &&
          component['types'][0] == 'administrative_area_level_1') {
        city = component['long_name'] as String?;
      }
    }

    return PlaceModel(
      placeId: map['place_id'] as String?,
      name: map['name'] as String?,
      latitude: (map['geometry']['location']['lat'] as num).toDouble(),
      longitude: (map['geometry']['location']['lng'] as num).toDouble(),
      country: country,
      city: city,
    );
  }
}
