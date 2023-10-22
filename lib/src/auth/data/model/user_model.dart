import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.status,
    super.profilePic,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.initialized,
  });

  const LocalUserModel.empty()
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

  LocalUserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String,
          email: map['email'] as String,
          status: map['status'] as String,
          profilePic: map['profilePic'] as String,
          firstName: map['firstName'] as String,
          lastName: map['lastName'] as String,
          phoneNumber: map['phoneNumber'] as String,
          initialized: map['initialized'] as bool,
          // integer: (map['integer'] as num).toInt(),
          // list: (map['list'] as List<dynamic>).cast<String>(),
        );

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'status': status,
      'profilePic': profilePic,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'initialized': initialized,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? status,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? initialized,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      status: status ?? this.status,
      profilePic: profilePic ?? this.profilePic,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      initialized: initialized ?? this.initialized,
    );
  }
}
