import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/datasources/location_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/place_autocomplete.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/location_repo.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepoImpl implements LocationRepo {
  const LocationRepoImpl(this._remoteDataSource);

  final LocationRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Position?> getCurrentLocation() async {
    try {
      final result = await _remoteDataSource.getCurrentLocation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<List<PlaceAutocomplete>?> getAutocomplete(
    String searchInput,
  ) async {
    try {
      final result = await _remoteDataSource.getAutocomplete(searchInput);
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<Place?> getPlace(String placeId) async {
    try {
      final result = await _remoteDataSource.getPlace(placeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }
}
