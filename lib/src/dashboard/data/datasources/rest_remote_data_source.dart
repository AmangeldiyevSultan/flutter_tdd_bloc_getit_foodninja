import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/model/restaurant_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';

abstract class RestRemoteDataSource {
  const RestRemoteDataSource();

  Future<List<RestaurantModel>> fetchRestaurants();

  Future<void> createRestaurant({
    required String name,
    required String description,
    required String image,
    required RestLocation location,
  });
}

class RestRemoteDataSourceImpl implements RestRemoteDataSource {
  const RestRemoteDataSourceImpl({
    required FirebaseFirestore cloudStoreClient,
  }) : _cloudStoreClient = cloudStoreClient;

  final FirebaseFirestore _cloudStoreClient;

  @override
  Future<void> createRestaurant({
    required String name,
    required String description,
    required String image,
    required RestLocation location,
  }) async {
    try {
      await _cloudStoreClient.collection('restaurants').doc().set(
            RestaurantModel(
              name: name,
              description: description,
              image: image,
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
