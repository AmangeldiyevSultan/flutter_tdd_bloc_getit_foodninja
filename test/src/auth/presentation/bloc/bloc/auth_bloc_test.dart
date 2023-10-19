import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/errors/failures.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/data/model/user_model.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/facebook_sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/forgot_password.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/google_sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/post_user_bio.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_up.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/update_user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockGoogleSignIn extends Mock implements GoogleSignInMethod {}

class MockFacebookSignIn extends Mock implements FacebookSignInMethod {}

class MockPostUserBio extends Mock implements PostUserBio {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late GoogleSignInMethod googleSignInMethod;
  late FacebookSignInMethod facebookSignInMethod;
  late PostUserBio postUserBio;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tPostUserBioParams = PostUserBioParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    googleSignInMethod = MockGoogleSignIn();
    facebookSignInMethod = MockFacebookSignIn();
    postUserBio = MockPostUserBio();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
      googleSignInMethod: googleSignInMethod,
      facebookSignInMethod: facebookSignInMethod,
      postUserBio: postUserBio,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tPostUserBioParams);
  });

  tearDown(() => authBloc.close());

  test('InitialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding  to this identifier.'
        ' The user may have been deleted',
  );

  group('FacebookSignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, FacebookSignedIn],'
      ' when [FacebookSignInEvent is added]',
      build: () {
        when(
          () => facebookSignInMethod(),
        ).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const FacebookSignInEvent(),
      ),
      expect: () => [
        const AuthLoading(),
        const FacebookSignedIn(tUser),
      ],
      verify: (_) {
        verify(() => facebookSignInMethod()).called(1);
        verifyNoMoreInteractions(facebookSignInMethod);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => facebookSignInMethod())
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const FacebookSignInEvent(),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => facebookSignInMethod()).called(1);
        verifyNoMoreInteractions(facebookSignInMethod);
      },
    );
  });

  group('GoogleSignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, GoogleSignedIn],'
      ' when [GoogleSignInEvent is added]',
      build: () {
        when(
          () => googleSignInMethod(),
        ).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const GoogleSignInEvent(),
      ),
      expect: () => [
        const AuthLoading(),
        const GoogleSignedIn(tUser),
      ],
      verify: (_) {
        verify(() => googleSignInMethod()).called(1);
        verifyNoMoreInteractions(googleSignInMethod);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => googleSignInMethod())
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const GoogleSignInEvent(),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => googleSignInMethod()).called(1);
        verifyNoMoreInteractions(googleSignInMethod);
      },
    );
  });

  group('PostUserBioEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserPostedBio] when '
      '[UserPostBioEvent is added]',
      build: () {
        when(
          () => postUserBio(any()),
        ).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UserPostBioEvent(
          firstName: tPostUserBioParams.firstName,
          lastName: tPostUserBioParams.lastName,
          phoneNumber: tPostUserBioParams.phoneNumber,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const UserBioPosted(tUser),
      ],
      verify: (_) {
        verify(() => postUserBio(tPostUserBioParams)).called(1);
        verifyNoMoreInteractions(postUserBio);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => postUserBio(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UserPostBioEvent(
          firstName: tPostUserBioParams.firstName,
          lastName: tPostUserBioParams.lastName,
          phoneNumber: tPostUserBioParams.phoneNumber,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => postUserBio(tPostUserBioParams)).called(1);
        verifyNoMoreInteractions(postUserBio);
      },
    );
  });
  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when [SignInEvent is added]',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer(
          (_) async => const Right(tUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when [SignUpEvent is added]',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signUn fails',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] when '
      '[ForgotPassword is added] and ForgotPassword succeed',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(
          'email',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when '
      '[forgotPasswordEvent] added and [ForgotPassword] fails',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(
          'email',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUserAction', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when '
      '[UpdateUserEvent] is added',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          userAction: tUpdateUserParams.userAction,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when '
      '[UpdateUserEvent] is added and [UpdateUser] fails',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          userAction: tUpdateUserParams.userAction,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
