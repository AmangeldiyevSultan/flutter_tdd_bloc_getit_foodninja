part of 'autocomplete_bloc.dart';

sealed class AutocompleteEvent extends Equatable {
  const AutocompleteEvent();

  @override
  List<Object> get props => [];
}

class LoadAutocompleteEvent extends AutocompleteEvent {
  const LoadAutocompleteEvent({this.searchInput = ''});

  final String searchInput;

  @override
  List<Object> get props => [searchInput];
}

class ClearAutocompleteEvent extends AutocompleteEvent {}
