import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/usecases/usecases.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/rest_repo.dart';

class CreateRestaurant
    extends UsecaseWithParams<void, CreateRestaurantPararms> {
  const CreateRestaurant(this._repo);

  final RestaurantRepo _repo;
  @override
  ResultFuture<void> call(CreateRestaurantPararms params) =>
      _repo.createRestaurant(
        name: params.name,
        image: params.image,
        location: params.location,
        description: params.decoration,
      );
}

class CreateRestaurantPararms extends Equatable {
  const CreateRestaurantPararms({
    required this.name,
    required this.decoration,
    required this.image,
    required this.location,
  });

  const CreateRestaurantPararms.empty()
      : this(
          name: '',
          decoration: '',
          image: '',
          location: const RestLocation.empty(),
        );

  final String name;
  final RestLocation location;
  final String decoration;
  final String image;

  @override
  List<Object?> get props => [name, location, decoration, image];
}
