import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/enum/update_user_action.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/facebook_sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/forgot_password.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/google_sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/post_user_bio.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_in.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/sign_up.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/use_cases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
    required GoogleSignInMethod googleSignInMethod,
    required FacebookSignInMethod facebookSignInMethod,
    required PostUserBio postUserBio,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        _googleSignInMethod = googleSignInMethod,
        _facebookSignInMethod = facebookSignInMethod,
        _postUserBio = postUserBio,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<GoogleSignInEvent>(_googleSignInHandler);
    on<FacebookSignInEvent>(_facebookSignInHandler);
    on<UserPostBioEvent>(_postUserBioHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
  final GoogleSignInMethod _googleSignInMethod;
  final FacebookSignInMethod _facebookSignInMethod;
  final PostUserBio _postUserBio;

  Future<void> _postUserBioHandler(
    UserPostBioEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _postUserBio(
      PostUserBioParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(UserBioPosted(user)),
    );
  }

  Future<void> _facebookSignInHandler(
    FacebookSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _facebookSignInMethod();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(FacebookSignedIn(user)),
    );
  }

  Future<void> _googleSignInHandler(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _googleSignInMethod();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(GoogleSignedIn(user)),
    );
  }

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(
      event.email,
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        userAction: event.userAction,
        userData: event.userData,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
