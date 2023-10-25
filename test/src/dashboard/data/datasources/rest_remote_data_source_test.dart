import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/datasources/rest_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/restaurant_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/data/datasources/auth_remote_data_source_test.dart';

void main() {
  late FirebaseFirestore cloudStoreClient;
  late FirebaseStorage dbClient;
  late RestRemoteDataSource remoteDataSource;
  late FirebaseAuth authClient;
  late Uuid uuid;

  setUp(() {
    cloudStoreClient = FakeFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    authClient = MockFirebaseAuth();
    uuid = const Uuid();
    remoteDataSource = RestRemoteDataSourceImpl(
      dbClient: dbClient,
      cloudStoreClient: cloudStoreClient,
      uuid: uuid,
      authClient: authClient,
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
        image: File(tRestaurantModel.image),
        location: tRestaurantModel.location,
      );

      expect(result, completes);
      verify(
        () => remoteDataSource.createRestaurant(
          name: tRestaurantModel.name,
          description: tRestaurantModel.description,
          image: File(tRestaurantModel.image),
          location: tRestaurantModel.location,
        ),
      ).called(1);

      verifyNoMoreInteractions(cloudStoreClient);
    });
  });
}
