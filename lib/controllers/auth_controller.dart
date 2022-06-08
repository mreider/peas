import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../config/constants.dart';

class AuthController {

  //SignUp user with email and password
  Future<String> signUpUser(
    String email,
    String password,
      String  name,
      BuildContext context
  ) async {
    try {
      String successMsg = '';

      final QuerySnapshot qSnap = await storeRefCollection.get();
      final int documents = qSnap.docs.length;

      if( documents == 0){
        UserCredential userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCreds.user;

        final String? userToken = await FirebaseMessaging.instance.getToken();
        assert(await user?.getIdToken() != null);
        await user?.reload();
        user?.sendEmailVerification();

        storeRefCollection.doc(user?.uid).set({
          'uid': user?.uid,
          'email': user?.email,
          'name' : name,
          'role' : 'admin'
        });

        adminRefCollection.doc(user?.uid).set({
          'id': user?.uid,
        });

        storeRefCollection
            .doc(user?.uid)
            .collection('tokens')
            .doc(userToken)
            .set({
          'userToken': userToken,
          'platform': Platform.isAndroid ? 'Android' : 'iOS',
        });

        successMsg = 'success';

      }else{
        successMsg = 'success';
        String adminId = await userController.getAdminID();
        QuerySnapshot allUsers = await adminRefCollection.doc(adminId.toString()).collection('invite').get();

        allUsers.docs.forEach((element) async{
          if(element['email'] == email){
            UserCredential userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
            User? user = userCreds.user;

            final String? userToken = await FirebaseMessaging.instance.getToken();
            assert(await user?.getIdToken() != null);
          await user?.reload();
          user?.sendEmailVerification();

            storeRefCollection.doc(user?.uid).set({
              'uid': user?.uid,
              'email': user?.email,
              'name' : name,
              'role' : 'user'
            });

            storeRefCollection
                .doc(user?.uid)
                .collection('tokens')
                .doc(userToken)
                .set({
              'userToken': userToken,
              'platform': Platform.isAndroid ? 'Android' : 'iOS',
            });
            print('else_fhfhhf');

          }

          successMsg = 'Try with different email.';

        });
      }

      return successMsg;
    } catch (e) {
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return 'The email address is already in use by another account.';
      }
      if (e.toString() ==
          '[firebase_auth/weak-password] Password should be at least 6 characters') {
        return 'Password should be at least 6 characters';
      }
      return e.toString();
    }
  }

  saveUserToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    storeRefCollection
        .doc(auth.currentUser!.uid)
        .collection('tokens')
        .doc(token)
        .set({
      'userToken': token,
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
  }

  //SignIn user with email and password
  signInUser(String email, String password) async {
    try {
      UserCredential userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final String? userToken = await FirebaseMessaging.instance.getToken();
      User? user = userCreds.user;
      await user?.reload();
      assert(await user?.getIdToken() != null);
      storeRefCollection
          .doc(user?.uid)
          .collection('tokens')
          .doc(userToken)
          .set({
        'userToken': userToken,
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
      });
      return 'success';
    } catch (e) {

      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        return 'Email address not found';
      } else if (e.toString() ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
        return 'Invalid password';
      } else {
        return e.toString();
      }
    }
  }


  //SignOut user
  Future<void> signOut() async {
    final String? userToken = await FirebaseMessaging.instance.getToken();
    storeRefCollection
        .doc(auth.currentUser!.uid)
        .collection('tokens')
        .doc(userToken)
        .delete();
    await FirebaseAuth.instance.signOut();
  }

}
