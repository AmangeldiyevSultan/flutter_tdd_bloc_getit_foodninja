import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';

class LocationModel extends RestLocation {
  const LocationModel({
    super.latitude,
    super.longitude,
    super.city,
    super.country,
  });

  const LocationModel.empty()
      : this(
          city: '',
          country: '',
          latitude: 0,
          longitude: 0,
        );

  LocationModel.fromMap(DataMap map)
      : this(
          city: map['city'] as String?,
          country: map['country'] as String?,
          latitude: map['latitude'] as double?,
          longitude: map['longitude'] as double?,
        );

  DataMap toMap() {
    return {
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LocationModel copyWith({
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return LocationModel(
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
