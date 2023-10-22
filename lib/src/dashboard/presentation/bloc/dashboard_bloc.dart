import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/create_restaurant.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/fetch_restaurants.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required CreateRestaurant createRestaurant,
    required FetchRestaurants fetchRestaurants,
  })  : _createRestaurant = createRestaurant,
        _fetchRestaurants = fetchRestaurants,
        super(const DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      emit(const DashBoardLoading());
    });
    on<CreateRestaurantEvent>(_createRestaurantHandler);
    on<FetchRestaurantsEvent>(_fetchRestaurantsHandler);
  }

  final CreateRestaurant _createRestaurant;
  final FetchRestaurants _fetchRestaurants;

  Future<void> _createRestaurantHandler(
    CreateRestaurantEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _createRestaurant(
      CreateRestaurantPararms(
        name: event.name,
        decoration: event.description,
        image: event.image,
        location: event.location,
      ),
    );

    result.fold(
      (failure) => emit(DashBoardError(failure.message)),
      (_) => emit(const CreatedRestaurant()),
    );
  }

  Future<void> _fetchRestaurantsHandler(
    FetchRestaurantsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _fetchRestaurants();

    result.fold(
      (failure) => emit(DashBoardError(failure.message)),
      (restaurants) => emit(FetchedRestaurants(restaurants)),
    );
  }
}
