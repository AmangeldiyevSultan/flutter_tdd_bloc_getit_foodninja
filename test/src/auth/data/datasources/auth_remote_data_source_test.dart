import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'tUid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseFirestore cloudStoreClient;
  late FirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late MockGoogleSignIn googleSignIn;

  late AuthRemoteDataSource dataSource;

  late UserCredential userCredential;
  late MockUser mockUser;

  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    authClient = MockFirebaseAuth();
    dbClient = MockFirebaseStorage();
    googleSignIn = MockGoogleSignIn();

    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );

    mockUser = MockUser()..uid = documentReference.id;

    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
      googleAuthClient: googleSignIn,
    );
    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'tPassword';
  const tEmail = 'tEmail';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no record corresponding to this identifier',
  );

  group('forgotPassword', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) => Future.value());

      final call = dataSource.forgotPassword(tEmail);

      expect(call, equals(completes));

      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      when(
        () => authClient.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = dataSource.forgotPassword(tEmail);

      expect(call, equals(throwsA(isA<ServerException>())));

      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('GoogleSignInUser', () async {
    test('should return idToken and accessToken when authenticating', () async {
      final signInAccount = await googleSignIn.signIn();
      final signInAuthentication = await signInAccount!.authentication;
      expect(signInAuthentication, isNotNull);
      expect(googleSignIn.currentUser, isNotNull);
      expect(signInAuthentication.accessToken, isNotNull);
      expect(signInAuthentication.idToken, isNotNull);
    });
    test('should return null when google login is cancelled by the user',
        () async {
      googleSignIn.setIsCancelled(true);
      final signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
    });
    test(
        'testing google login twice, once cancelled,'
        ' once not cancelled at the same test.', () async {
      googleSignIn.setIsCancelled(true);
      final signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
      googleSignIn.setIsCancelled(false);
      final signInAccountSecondAttempt = await googleSignIn.signIn();
      expect(signInAccountSecondAttempt, isNotNull);
    });

    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(() => googleSignIn.signIn()).thenAnswer((_) async => signInAccount);

      when(
        () => authClient.signInWithCredential(credential),
      ).thenAnswer((_) async => userCredential);

      final result = await dataSource.googleSignIn();

      expect(result.uid, userCredential.user!.uid);
      expect(result.lastName, '');
      verify(
        () => googleSignIn.signIn(),
      ).called(1);
      verify(
        () => authClient.signInWithCredential(credential),
      ).called(1);
      verifyNoMoreInteractions(authClient);
      verifyNoMoreInteractions(googleSignIn);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is'
        ' thrown', () {
      when(() => googleSignIn.signIn()).thenAnswer((_) async => signInAccount);
      when(
        () => authClient.signInWithCredential(credential),
      ).thenThrow(tFirebaseAuthException);

      final result = dataSource.googleSignIn();

      verify(
        () => googleSignIn.signIn(),
      ).called(1);
      expect(result, equals(throwsA(isA<ServerException>())));
      verify(() => authClient.signInWithCredential(credential)).called(1);
      verifyNoMoreInteractions(authClient);
      verifyNoMoreInteractions(googleSignIn);
    });

    test('should throw [ServerException] when user is null after sign in', () {
      when(() => googleSignIn.signIn()).thenAnswer((_) async => signInAccount);

      final emptyUserCredential = MockUserCredential();
      when(() => authClient.signInWithCredential(credential))
          .thenAnswer((_) async => emptyUserCredential);

      final call = dataSource.googleSignIn;

      expect(
        call,
        equals(
          throwsA(
            isA<ServerException>(),
          ),
        ),
      );
      verify(
        () => googleSignIn.signIn(),
      ).called(1);
      verify(
        () => authClient.signInWithCredential(credential),
      ).called(1);
      verifyNoMoreInteractions(authClient);
      verifyNoMoreInteractions(googleSignIn);
    });
  });

  group('signIn', () {
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);
      final result =
          await dataSource.signIn(email: tEmail, password: tPassword);

      expect(result.uid, userCredential.user!.uid);
      expect(result.lastName, '');
      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is'
        ' thrown', () {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final result = dataSource.signIn(email: tEmail, password: tPassword);

      expect(result, equals(throwsA(isA<ServerException>())));
      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw [ServerException] when user is null after sign in', () {
      final emptyUserCredential = MockUserCredential();
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: 'password',
        ),
      ).thenAnswer((_) async => emptyUserCredential);

      final call = dataSource.signIn;

      expect(
        () => call(email: tEmail, password: tPassword),
        equals(
          throwsA(
            isA<ServerException>(),
          ),
        ),
      );
      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('singUp', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      final call = dataSource.signUp(email: tEmail, password: tPassword);

      expect(call, completes);

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      // when(
      //   () => userCredential.user?.updateDisplayName(any()),).thenAnswer(
      //   (_) => Future.value(),
      // );
      // await untilCalled(() => userCredential.user?.updateDisplayName(any()));
      // verify(() => userCredential.user?.displayName).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is'
        ' thrown', () {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final result = dataSource.signUp(email: tEmail, password: tPassword);

      expect(result, equals(throwsA(isA<ServerException>())));
      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test(
        'should update user email successfully when no [Exception] is '
        ' thrown', () async {
      when(() => mockUser.updateEmail(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await dataSource.updateUser(
        userAction: UpdateUserAction.email,
        userData: tEmail,
      );

      verify(() => mockUser.updateEmail(tEmail)).called(1);

      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );

      final user =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(user.data()!['email'], tEmail);
    });

    test(
        'should update user firstName successfully when no [Exception] is '
        ' thrown', () async {
      const newFirstName = 'tFirstName';

      await dataSource.updateUser(
        userAction: UpdateUserAction.firstName,
        userData: newFirstName,
      );

      final user =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(user.data()!['firstName'], newFirstName);

      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
    });

    test(
        'should update user lastName successfully when no [Exception] is '
        ' thrown', () async {
      const newLastName = 'tLastName';

      await dataSource.updateUser(
        userAction: UpdateUserAction.lastName,
        userData: newLastName,
      );

      final user =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(user.data()!['lastName'], newLastName);
      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
    });

    test(
        'should update user password successfully when no [Exception] is '
        ' thrown', () async {
      when(
        () => mockUser.updatePassword(any()),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      when(
        () => mockUser.reauthenticateWithCredential(any()),
      ).thenAnswer((_) async => userCredential);

      when(() => mockUser.email).thenReturn(tEmail);

      await dataSource.updateUser(
        userAction: UpdateUserAction.password,
        userData: jsonEncode(
          {'oldPassword': 'oldPassword', 'newPassword': tPassword},
        ),
      );

      verify(() => mockUser.updatePassword(tPassword));

      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );

      final user = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();

      expect(user.data()!['password'], null);
    });

    test(
        'should update user profilePic successfully when no [Exception] is '
        ' thrown', () async {
      final newProfilePic = File('assets/images/logo-splash.png');

      when(
        () => mockUser.updatePhotoURL(any()),
      ).thenAnswer((invocation) async => Future.value());

      await dataSource.updateUser(
        userAction: UpdateUserAction.profilePic,
        userData: newProfilePic,
      );

      verify(
        () => mockUser.updatePhotoURL(any()),
      ).called(1);

      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );

      expect(dbClient.storedFilesMap.isNotEmpty, equals(isTrue));
    });
  });
}
