part of 'autocomplete_bloc.dart';

sealed class AutocompleteState extends Equatable {
  const AutocompleteState();

  @override
  List<Object> get props => [];
}

final class AutocompleteInitial extends AutocompleteState {}

class AutocompleteLoading extends AutocompleteState {}

class AutocompleteCleared extends AutocompleteState {
  const AutocompleteCleared({required this.autocomplete});

  final List<PlaceAutocomplete> autocomplete;

  @override
  List<Object> get props => [autocomplete];
}

class AutocompleteLoaded extends AutocompleteState {
  const AutocompleteLoaded({required this.autocomplete});

  final List<PlaceAutocomplete> autocomplete;

  @override
  List<Object> get props => [autocomplete];
}

class AutocompleteError extends AutocompleteState {
  const AutocompleteError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
