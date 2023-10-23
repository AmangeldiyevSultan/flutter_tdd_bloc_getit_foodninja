import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/constants.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/model/place_authcomplete_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/model/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

abstract class LocationRemoteDataSource {
  const LocationRemoteDataSource();

  Future<Position?> getCurrentLocation();

  Future<List<PlaceAutocompleteModel>> getAutocomplete(String searchInput);

  Future<PlaceModel> getPlace(String placeId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  const LocationRemoteDataSourceImpl({
    required http.Client client,
  }) : _client = client;

  final http.Client _client;

  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    } else {
      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  @override
  Future<List<PlaceAutocompleteModel>> getAutocomplete(
    String searchInput,
  ) async {
    try {
      final url =
          '${Constants.kBaseUrl}/${Constants.kAutocompleteJsonUrl}?input=$searchInput&types=${Constants.kMapTypes}&key=${Constants.kMapApiKey}';

      final response = await _client.get(Uri.parse(url));

      final map = convert.jsonDecode(response.body) as DataMap;

      final result = map['predictions'] as List;

      final autocompleteData = result
          .map((place) => PlaceAutocompleteModel.fromMap(place as DataMap))
          .toList();

      return autocompleteData;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<PlaceModel> getPlace(String placeId) async {
    final url =
        '${Constants.kBaseUrl}/${Constants.kPlaceDetailsJsonUrl}?place_id=$placeId&key=${Constants.kMapApiKey}';

    final response = await http.get(Uri.parse(url));
    final json = convert.jsonDecode(response.body) as DataMap;
    final results = json['result'] as DataMap;
    return PlaceModel.fromMap(results);
  }
}
