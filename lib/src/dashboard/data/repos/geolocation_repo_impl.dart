import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/datasources/geolocation_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/repo/getlocation_repo.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationRepoImpl implements GeoLocationRepo {
  const GeoLocationRepoImpl(this._remoteDataSource);

  final GeoLocationRemoteDataSource _remoteDataSource;

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
}
