import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.latitude,
    required this.longitude,
    this.placeId,
    this.name,
    this.city,
    this.country,
  });

  const Place.empty()
      : this(
          placeId: '',
          name: '',
          city: '',
          country: '',
          latitude: 0,
          longitude: 0,
        );

  final String? placeId;
  final String? name;
  final String? city;
  final String? country;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [placeId];
}
