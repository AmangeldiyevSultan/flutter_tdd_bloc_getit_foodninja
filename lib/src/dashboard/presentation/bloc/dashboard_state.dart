part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class CreatedRestaurant extends DashboardState {
  const CreatedRestaurant();
}

class FetchedRestaurants extends DashboardState {
  const FetchedRestaurants(this.restaurants);

  final List<Restaurant> restaurants;

  @override
  List<Object> get props => [restaurants];
}

class DashBoardLoading extends DashboardState {
  const DashBoardLoading();
}

class DashBoardError extends DashboardState {
  const DashBoardError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
