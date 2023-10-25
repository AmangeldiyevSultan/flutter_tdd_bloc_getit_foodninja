import 'dart:convert';

import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/location/domain/entities/place_autocomplete.dart';

class PlaceAutocompleteModel extends PlaceAutocomplete {
  const PlaceAutocompleteModel({
    required super.description,
    required super.placeId,
  });

  const PlaceAutocompleteModel.empty() : this(description: '', placeId: '');

  PlaceAutocompleteModel.fromMap(DataMap map)
      : this(
          description: map['description'] as String,
          placeId: map['place_id'] as String,
        );

  factory PlaceAutocompleteModel.fromJson(String source) =>
      PlaceAutocompleteModel.fromMap(json.decode(source) as DataMap);
}
