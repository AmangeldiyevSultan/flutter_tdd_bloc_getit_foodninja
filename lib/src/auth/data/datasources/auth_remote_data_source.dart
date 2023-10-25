import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/app/providers/user_provider.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/location_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<LocalUserModel> postUserBio({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> facebookSignIn();

  Future<LocalUserModel> googleSignIn();

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction userAction,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required GoogleSignIn googleAuthClient,
    required FacebookAuth facebookAuth,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient,
        _googleAuthClient = googleAuthClient,
        _facebookAuth = facebookAuth;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final GoogleSignIn _googleAuthClient;
  final FacebookAuth _facebookAuth;

  @override
  Future<LocalUserModel> postUserBio({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final user = _authClient.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      await _updateUserData({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'initialized': true,
      });

      final userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<LocalUserModel> facebookSignIn() async {
    try {
      final facebookAuthResult = await _facebookAuth.login();

      final facebookAuthCredential = FacebookAuthProvider.credential(
        facebookAuthResult.accessToken!.token,
      );

      final result =
          await _authClient.signInWithCredential(facebookAuthCredential);

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }
      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, user.email!);

      userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
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
  Future<LocalUserModel> googleSignIn() async {
    try {
      final googleUser = await _googleAuthClient.signIn();
      if (googleUser == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _authClient.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, user.email!);

      userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
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
  Future<void> forgotPassword(
    String email,
  ) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, email);

      userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
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
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _setUserData(userCred.user!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction userAction,
    required dynamic userData,
  }) async {
    try {
      switch (userAction) {
        case UpdateUserAction.location:
          if (userData != null) {
            final locationData = userData as LocationModel;

            await _updateUserData({'location': locationData.toMap()});
          }
        case UpdateUserAction.phoneNumber:
          await _updateUserData({'phoneNumber': userData});
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.firstName:
          await _updateUserData({'firstName': userData});
        case UpdateUserAction.lastName:
          await _updateUserData({'lastName': userData});

        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser?.uid}');

          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
          final userProvider = UserProvider();
          userProvider.user?.copyWith(profilePic: url);

        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured!',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(
    User user,
    String fallbackEmail,
  ) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            status: 'user',
            profilePic: '',
            firstName: '',
            lastName: '',
            phoneNumber: '',
            initialized: false,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(
          _authClient.currentUser?.uid,
        )
        .update(data);
  }
}
