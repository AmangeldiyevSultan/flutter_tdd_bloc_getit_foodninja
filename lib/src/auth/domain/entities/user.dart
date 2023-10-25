import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/domain/entities/location.dart';

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
    this.location,
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
          location: null,
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
  final RestLocation? location;

  @override
  List<Object?> get props => [uid];
}
