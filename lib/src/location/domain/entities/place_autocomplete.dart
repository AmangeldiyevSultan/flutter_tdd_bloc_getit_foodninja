import 'package:equatable/equatable.dart';

class PlaceAutocomplete extends Equatable {
  const PlaceAutocomplete({required this.description, required this.placeId});

  const PlaceAutocomplete.empty()
      : this(
          description: '',
          placeId: '',
        );

  final String description;
  final String placeId;

  @override
  List<Object?> get props => [];
}
