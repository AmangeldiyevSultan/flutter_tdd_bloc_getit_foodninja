part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

class FacebookSignInEvent extends AuthEvent {
  const FacebookSignInEvent();

  @override
  List<String> get props => [];
}

class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();

  @override
  List<String> get props => [];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent(this.email);

  final String email;

  @override
  List<String> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.userAction,
    required this.userData,
  }) : assert(
            userData is String || userData is File,
            '[userData] must be either a String or a File, '
            'but was ${userData.runtimeType}');

  final UpdateUserAction userAction;
  final dynamic userData;

  @override
  List<Object?> get props => [userAction, userData];
}
