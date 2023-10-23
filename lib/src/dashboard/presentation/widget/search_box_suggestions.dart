import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/views/loading_view.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/presentation/bloc/autocomplete/autocomplete_bloc.dart';

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
                  onTap: () {},
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
