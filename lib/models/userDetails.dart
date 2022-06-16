import 'package:flutter/foundation.dart';

@immutable
class UserDetails {
  final String uid;
  final String name;
  final String email;
  final String role;

  UserDetails(this.uid, this.name , this.email , this.role);

  UserDetails.fromJson(Map<String, Object?> json)
      : this(
          json['uid'] as String? ?? '',
          json['name'] as String? ?? '',
          json['email'] as String? ?? '',
          json['role'] as String? ?? '',
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
      'role': role,
    };
  }
}
