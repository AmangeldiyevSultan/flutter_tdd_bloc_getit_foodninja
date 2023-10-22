import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/datasources/rest_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/model/restaurant_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FirebaseFirestore cloudStoreClient;
  late RestRemoteDataSource remoteDataSource;

  setUp(() {
    cloudStoreClient = FakeFirebaseFirestore();
    remoteDataSource = RestRemoteDataSourceImpl(
      cloudStoreClient: cloudStoreClient,
    );
  });

  const tRestaurantModel = RestaurantModel.empty();

  group('create restaurant', () {
    test('should complete successfully when no [Exception] is thrown', () {
      when(
        () => cloudStoreClient.collection(any(named: 'restaurant')).doc().set(
              any(named: 'Model'),
            ),
      ).thenAnswer((_) async => const Right<dynamic, void>(null));

      final result = remoteDataSource.createRestaurant(
        name: tRestaurantModel.name,
        description: tRestaurantModel.description,
        image: tRestaurantModel.image,
        location: tRestaurantModel.location,
      );

      expect(result, completes);
      verify(
        () => remoteDataSource.createRestaurant(
          name: tRestaurantModel.name,
          description: tRestaurantModel.description,
          image: tRestaurantModel.image,
          location: tRestaurantModel.location,
        ),
      ).called(1);

      verifyNoMoreInteractions(cloudStoreClient);
    });
  });
}
