import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  const Place.empty()
      : this(
          placeId: '',
          name: '',
          latitude: '',
          longitude: '',
        );

  final String placeId;
  final String name;
  final String latitude;
  final String longitude;

  @override
  List<Object?> get props => [placeId];
}
