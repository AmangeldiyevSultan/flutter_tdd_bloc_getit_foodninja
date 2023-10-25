import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/services/injection_container.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/restaurant_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';
import 'package:uuid/uuid.dart';

abstract class RestRemoteDataSource {
  const RestRemoteDataSource();

  Future<List<RestaurantModel>> fetchRestaurants();

  Future<void> createRestaurant({
    required String name,
    required String description,
    required File image,
    required RestLocation location,
  });
}

class RestRemoteDataSourceImpl implements RestRemoteDataSource {
  const RestRemoteDataSourceImpl({
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required Uuid uuid,
  })  : _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient,
        _uuid = uuid;

  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final Uuid _uuid;

  @override
  Future<void> createRestaurant({
    required String name,
    required String description,
    required File image,
    required RestLocation location,
  }) async {
    try {
      final ref = _dbClient.ref().child('restaurants/${_uuid.v4()}');

      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      await _cloudStoreClient.collection('restaurants').doc().set(
            RestaurantModel(
              name: name,
              description: description,
              image: url,
              location: location,
            ).toMap(),
          );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<RestaurantModel>> fetchRestaurants() async {
    try {
      final restaurantsList = <RestaurantModel>[];
      final restaurants =
          await _cloudStoreClient.collection('restaurants').get();

      for (final DocumentSnapshot restaurant in restaurants.docs) {
        restaurantsList.add(
          RestaurantModel.fromMap(restaurant as DataMap),
        );
      }

      return restaurantsList;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }
}
