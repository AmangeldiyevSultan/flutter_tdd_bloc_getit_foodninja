import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.placeId,
    required super.name,
    required super.latitude,
    required super.longitude,
  });

  const PlaceModel.empty()
      : this(
          placeId: '',
          name: '',
          latitude: '',
          longitude: '',
        );

  PlaceModel.fromMap(DataMap map)
      : this(
          placeId: map['place_id'] as String,
          name: map['name'] as String,
          latitude: map['latitude'] as String,
          longitude: map['longitude'] as String,
        );
}
