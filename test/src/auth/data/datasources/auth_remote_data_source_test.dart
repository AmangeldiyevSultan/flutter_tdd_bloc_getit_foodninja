import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/exceptions.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCredential extends Mock implements OAuthCredential {
  int _token = 1234;
  String _accessToken = 'tAccessToken_auth';
  String _idToken = 'tIdToken_auth';

  @override
  int? get token => _token;
  set token(int? value) {
    if (_token != value) _token = value!;
  }

  @override
  String? get accessToken => _accessToken;
  set accessToken(String? value) {
    if (_accessToken != value) _accessToken = value!;
  }

  @override
  String? get idToken => _idToken;
  set idToken(String? value) {
    if (_idToken != value) _idToken = value!;
  }
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockGoogleAuth extends Mock implements GoogleSignIn {}

class MockGoogleSignInAcc extends Mock implements GoogleSignInAccount {
  MockGoogleSignInAcc([
    GoogleSignInAuthentication? signInAuthentication,
  ]) : _signInAuthentication = signInAuthentication;

  final GoogleSignInAuthentication? _signInAuthentication;

  @override
  Future<GoogleSignInAuthentication> get authentication async =>
      _signInAuthentication!;
}

class MockGoogleAccountAuthentication extends Mock
    implements GoogleSignInAuthentication {
  String _accessToken = 'tAccessToken';
  String _idToken = 'tIdToken';

  @override
  String get idToken => _idToken;
  set idToken(String value) {
    if (_idToken != value) _idToken = value;
  }

  @override
  String get accessToken => _accessToken;
  set accessToken(String value) {
    if (_accessToken != value) _accessToken = value;
  }
}

class MockUser extends Mock implements User {
  String _uid = 'tUid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockGoogleUserCredential extends Mock implements UserCredential {}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late GoogleSignIn googleSignIn;
  late GoogleSignInAccount googleSignInAccount;
  late FacebookAuth facebookAuth;

  late AuthRemoteDataSource dataSource;

  late UserCredential userCredential;
  late UserCredential googleUserCredential;
  late MockUser mockUser;
  late GoogleSignInAuthentication googleSignInAuthentication;

  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    authClient = MockFirebaseAuth();
    dbClient = MockFirebaseStorage();
    googleSignIn = MockGoogleAuth();
    facebookAuth = MockFacebookAuth();

    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );

    mockUser = MockUser()..uid = documentReference.id;
    googleSignInAuthentication = MockGoogleAccountAuthentication();

    googleSignInAccount = MockGoogleSignInAcc(googleSignInAuthentication);
    googleUserCredential = MockGoogleUserCredential();
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
      googleAuthClient: googleSignIn,
      facebookAuth: facebookAuth,
    );
    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'tPassword';
  const tEmail = 'tEmail';
  const tFirstName = 'tFirstName';
  const tLastName = 'tLastName';
  const tPhoneNumber = 'tPhoneNumber';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no record corresponding to this identifier',
  );

  final tFirebaseException = FirebaseException(
    plugin: 'Error',
    code: 'collection-not-found',
    message: 'There is no record corresponding to this identifier',
  );

  group('userPostBio', () {
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      final result = await dataSource.postUserBio(
        firstName: tFirstName,
        lastName: tLastName,
        phoneNumber: tPhoneNumber,
      );
      expect(result.firstName, equals(tFirstName));
      expect(result.phoneNumber, equals(tPhoneNumber));
      expect(result.lastName, equals(tLastName));
      expect(result, equals(isA<LocalUserModel>()));
    });

    test(
        'should throw [ServerException] when [FirebaseException] is'
        ' thrown', () {
      when(
        () async => dataSource.postUserBio(
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
        ),
      ).thenThrow(tFirebaseException);

      final result = dataSource.postUserBio(
        firstName: tFirstName,
        lastName: tLastName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, equals(throwsA(isA<ServerException>())));
      verify(
        () => dataSource.postUserBio(
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
        ),
      ).called(1);
      verifyNoMoreInteractions(cloudStoreClient);
    });

    test('should throw [ServerException] when user is null after sign in', () {
      when(
        () => dataSource.postUserBio(
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
        ),
      ).thenAnswer((_) async => const LocalUserModel.empty());

      final call = dataSource.postUserBio;

      expect(
        () async => call(
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
        ),
        equals(
          throwsA(
            isA<ServerException>(),
          ),
        ),
      );
      verify(
        () => dataSource.postUserBio(
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('forgotPassword', () {
    test('should complete successfully when no [Exception] is thrown', () {
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
        () {
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

  group('GoogleSignInUser', () {
    late OAuthCredential googleCred;

    setUp(() async {
      googleCred = MockAuthCredential();
      final gAuth = await googleSignInAccount.authentication;

      googleCred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
    });
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(
        () => googleSignIn.signIn(),
      ).thenAnswer((_) async => googleSignInAccount);

      when(
        GoogleAuthProvider.credential,
      ).thenAnswer((_) => googleCred);

      when(
        () => authClient.signInWithCredential(googleCred),
      ).thenAnswer((_) async => googleUserCredential);

      final result = await dataSource.googleSignIn();

      expect(result.lastName, '');
      verify(
        () => authClient.signInWithCredential(googleCred),
      ).called(1);
      verify(
        () => googleSignIn.signIn(),
      ).called(1);
      verifyNoMoreInteractions(authClient);
      verifyNoMoreInteractions(googleCred);
    });

    // test(
    //     'should throw [ServerException] when [FirebaseAuthException] is'
    //     ' thrown', () {
    //   when(() => googleSignIn.signIn())
    //       .thenAnswer((_) async => googleSignInAccount);
    //   when(
    //     () => authClient.signInWithCredential(any()),
    //   ).thenThrow(tFirebaseAuthException);

    //   final result = dataSource.googleSignIn();

    //   verify(
    //     () => googleSignIn.signIn(),
    //   ).called(1);
    //   expect(result, equals(throwsA(isA<ServerException>())));
    //   verify(() => authClient.signInWithCredential(any())).called(1);
    //   verifyNoMoreInteractions(authClient);
    //   verifyNoMoreInteractions(googleSignIn);
    // });

    // test('should throw [ServerException] when user is null after sign in', ()
    // {
    //   when(() => googleSignIn.signIn()).thenAnswer(
    //     (_) async => googleSignInAccount,
    //   );

    //   final emptyUserCredential = MockUserCredential();
    //   when(() => authClient.signInWithCredential(any()))
    //       .thenAnswer((_) async => emptyUserCredential);

    //   final call = dataSource.googleSignIn;

    //   expect(
    //     call,
    //     equals(
    //       throwsA(
    //         isA<ServerException>(),
    //       ),
    //     ),
    //   );
    //   verify(
    //     () => googleSignIn.signIn(),
    //   ).called(1);
    //   verify(
    //     () => authClient.signInWithCredential(any()),
    //   ).called(1);
    //   verifyNoMoreInteractions(authClient);
    //   verifyNoMoreInteractions(googleSignIn);
    // });
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
