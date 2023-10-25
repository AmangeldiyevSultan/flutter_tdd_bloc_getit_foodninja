part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class FetchRestaurantsEvent extends DashboardEvent {
  const FetchRestaurantsEvent();

  @override
  List<Object?> get props => [];
}

class CreateRestaurantEvent extends DashboardEvent {
  const CreateRestaurantEvent({
    required this.name,
    required this.description,
    required this.image,
    required this.location,
  });

  final String name;
  final String description;
  final File image;
  final RestLocation location;

  @override
  List<Object?> get props => [name, description, image, location];
}
