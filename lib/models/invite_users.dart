import 'package:flutter/foundation.dart';

@immutable
class InviteUsers {
  final String email;




  InviteUsers(this.email);

  InviteUsers.fromJson(Map<String, Object?> json)
      : this(

    json['email'] as String? ?? '',

  );

  @override
  String toString() {
    return this.email;
  }

  Map<String, Object?> toJson() {
    return {

      'email': email,

    };
  }
}
