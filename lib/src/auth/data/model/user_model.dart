import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    super.profilePic,
    super.firstName,
    super.lastName,
    super.phoneNumber,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          profilePic: '',
          firstName: '',
          lastName: '',
          phoneNumber: '',
        );

  LocalUserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String,
          email: map['email'] as String,
          profilePic: map['profilePic'] as String,
          firstName: map['firstName'] as String,
          lastName: map['lastName'] as String,
          phoneNumber: map['phoneNumber'] as String,
          // integer: (map['integer'] as num).toInt(),
          // list: (map['list'] as List<dynamic>).cast<String>(),
        );

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
