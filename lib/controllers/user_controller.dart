import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../models/userDetails.dart';


class UserController {

  Future<String> addUserInfo(Map<String, dynamic> userInfo) async {
    try {
      await storeRefCollection.doc(auth.currentUser?.uid).update(userInfo);
      return 'success';
    } catch (e) {
      return 'error';
    }
  }


  void saveToken() async {
    print('saving token....');
    if (auth.currentUser != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      storeRefCollection
          .doc(auth.currentUser!.uid)
          .collection('tokens')
          .doc(token)
          .set({'userToken': token});
    }
  }


  //Get user information
  Future<UserDetails> getUserById(String userID) async {
    print('userID - $userID');
    DocumentSnapshot _user = await storeRefCollection.doc(userID).get();
    Map<String, dynamic> userDocument = _user.data() as Map<String, dynamic>;
    return UserDetails.fromJson(userDocument);
  }

}
