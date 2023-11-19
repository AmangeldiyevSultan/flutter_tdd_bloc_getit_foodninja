import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/utils/typedef.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/domain/entities/user.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/data/models/location_model.dart';

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
    super.location,
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
          location: null,
          initialized: false,
        );

  factory LocalUserModel.fromMap(DataMap map) {
    LocationModel? location;
    if (map['location'] != null) {
      location = LocationModel.fromMap(map['location'] as DataMap);
    }

    return LocalUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      status: map['status'] as String,
      profilePic: map['profilePic'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      initialized: map['initialized'] as bool?,
      location: location,
    );
  }

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
      'location': {
        'city': location!.city,
        'country': location!.country,
        'latitude': location!.latitude,
        'longitude': location!.longitude,
      },
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
    LocationModel? location,
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
      location: location ?? this.location,
    );
  }
}
