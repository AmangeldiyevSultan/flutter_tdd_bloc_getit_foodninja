import 'package:geolocator/geolocator.dart';

abstract class GeoLocationRemoteDataSource {
  const GeoLocationRemoteDataSource();

  Future<Position?> getCurrentLocation();
}

class GeoLocationRemoteDataSourceImpl implements GeoLocationRemoteDataSource {
  const GeoLocationRemoteDataSourceImpl();

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
}
