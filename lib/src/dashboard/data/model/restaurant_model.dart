import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/model/location_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.uid,
    required super.name,
    required super.description,
    required super.image,
    required super.location,
  });

  const RestaurantModel.empty()
      : this(
          uid: '',
          name: '',
          description: '',
          image: '',
          location: const LocationModel.empty(),
        );

  RestaurantModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String,
          name: map['name'] as String,
          description: map['description'] as String,
          image: map['image'] as String,
          location: LocationModel.fromMap(map['location'] as DataMap),
        );

  DataMap toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'image': image,
      'location': {
        'city': location.city,
        'country': location.country,
        'latitude': location.latitude,
        'longitude': location.longitude,
      }
    };
  }

  RestaurantModel copyWith({
    String? uid,
    String? name,
    String? description,
    String? image,
    LocationModel? location,
  }) {
    return RestaurantModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      location: location ?? this.location,
    );
  }
}
