import 'package:equatable/equatable.dart';

class RestLocation extends Equatable {
  const RestLocation({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });

  const RestLocation.empty()
      : this(
          city: '',
          country: '',
          latitude: 0,
          longitude: 0,
        );

  final double? longitude;
  final double? latitude;
  final String? city;
  final String? country;

  @override
  List<Object?> get props => [latitude, longitude];
}
