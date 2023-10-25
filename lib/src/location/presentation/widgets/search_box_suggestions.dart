import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/bloc/autocomplete/autocomplete_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/presentation/bloc/location/location_bloc.dart';

class SearchBoxSuggestions extends StatelessWidget {
  const SearchBoxSuggestions({
    required this.searchController,
    super.key,
  });

  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutocompleteBloc, AutocompleteState>(
      builder: (context, state) {
        if (state is AutocompleteLoading) {
          return const LoadingView();
        }
        if (state is AutocompleteLoaded) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.autocomplete.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    state.autocomplete[index].description,
                  ),
                  onTap: () {
                    context.read<LocationBloc>().add(
                          SearchLocationEvent(
                            placeId: state.autocomplete[index].placeId,
                          ),
                        );
                    context.read<AutocompleteBloc>().add(
                          ClearAutocompleteEvent(),
                        );
                  },
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
