import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.profilePic,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  const LocalUser.empty() 
  : this(
    uid: '',
    email: '',
    profilePic: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
  ); 

  final String uid;
  final String email;
  final String? profilePic;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  @override
  List<Object?> get props => [uid];
}
