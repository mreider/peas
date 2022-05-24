import 'package:flutter/foundation.dart';

@immutable
class UserDetails {
  final String uid;
  final String name;
  final String email;



  UserDetails(
      this.uid, this.name , this.email);

  UserDetails.fromJson(Map<String, Object?> json)
      : this(
          json['uid'] as String? ?? '',
          json['name'] as String? ?? '',
          json['email'] as String? ?? '',
        );

  @override
  String toString() {
    return this.uid;
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}
