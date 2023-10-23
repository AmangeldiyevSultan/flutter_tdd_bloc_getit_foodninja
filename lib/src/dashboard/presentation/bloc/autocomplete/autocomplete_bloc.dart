import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place_autocomplete.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/use_cases/get_autocomplete.dart';

part 'autocomplete_event.dart';
part 'autocomplete_state.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  AutocompleteBloc({
    required GetAutocomplete getAutocomplete,
  })  : _getAutocomplete = getAutocomplete,
        super(AutocompleteInitial()) {
    on<AutocompleteEvent>((event, emit) {
      emit(AutocompleteLoading());
    });
    on<LoadAutocompleteEvent>(_onLoadAutocompleteHandler);
    on<ClearAutocompleteEvent>(_onClearAutocomplete);
  }

  final GetAutocomplete _getAutocomplete;

  Future<void> _onLoadAutocompleteHandler(
    LoadAutocompleteEvent event,
    Emitter<AutocompleteState> emit,
  ) async {
    final result = await _getAutocomplete(event.searchInput);

    result.fold(
      (failure) => emit(AutocompleteError(failure.message)),
      (autocomplete) => emit(AutocompleteLoaded(autocomplete: autocomplete!)),
    );
  }

  Future<void> _onClearAutocomplete(
    ClearAutocompleteEvent event,
    Emitter<AutocompleteState> emit,
  ) async {
    emit(AutocompleteLoaded(autocomplete: List.empty()));
  }
}
