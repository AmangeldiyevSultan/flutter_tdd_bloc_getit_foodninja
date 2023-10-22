import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.name,
    required this.image,
    required this.location,
    required this.description,
  });

  const Restaurant.empty()
      : this(
          description: '',
          name: '',
          image: '',
          location: const RestLocation.empty(),
        );

  final String name;
  final RestLocation location;
  final String image;
  final String description;

  @override
  List<Object?> get props => [name];
}
