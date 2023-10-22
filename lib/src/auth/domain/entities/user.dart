import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.status,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.initialized,
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          status: '',
          profilePic: '',
          firstName: '',
          lastName: '',
          phoneNumber: '',
          initialized: false,
        );

  final String uid;
  final String email;
  final String? profilePic;
  final String? firstName;
  final String? lastName;
  final String status;
  final String? phoneNumber;
  final bool? initialized;

  @override
  List<Object?> get props => [uid];
}
