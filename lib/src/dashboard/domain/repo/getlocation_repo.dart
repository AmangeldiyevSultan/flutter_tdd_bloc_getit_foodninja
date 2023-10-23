import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeoLocationRepo {
  const GeoLocationRepo();

  ResultFuture<Position?> getCurrentLocation();
}
