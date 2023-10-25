import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/datasources/rest_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/restaurant.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/rest_repo.dart';

class RestaurantRepoImpl implements RestaurantRepo {
  const RestaurantRepoImpl(this._remoteDataSource);

  final RestRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createRestaurant({
    required String name,
    required File image,
    required RestLocation location,
    required String description,
  }) async {
    try {
      await _remoteDataSource.createRestaurant(
        name: name,
        image: image,
        location: location,
        description: description,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  ResultFuture<List<Restaurant>> fetchRestaurants() async {
    try {
      final result = await _remoteDataSource.fetchRestaurants();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }
}
