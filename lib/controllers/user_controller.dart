import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/constants.dart';
import '../models/invite_users.dart';
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

  //Get all users from users
  Future<List<UserDetails>> getAllUsers() async {
    QuerySnapshot allUsers = await storeRefCollection.get();
    List<UserDetails> users = allUsers.docs
        .map((e) => UserDetails.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return users;
  }

  Future<String> getAdminID() async {
    final QuerySnapshot adminSnap = await adminRefCollection.get();

    String adminId = '';
    adminSnap.docs.forEach((element) {
      adminId = element['id'];

      print('admin_role -${element['id']}');
    });

    return adminId;
  }

  //Get all users from users
  Future<List<InviteUsers>> getUsersInviteEmails() async {
    List<InviteUsers> users = [];
    try {
      String adminId = await getAdminID();
      QuerySnapshot allUsers = await adminRefCollection
          .doc(adminId.toString())
          .collection('invite')
          .get();
      print('allUsers_lenght -- ${allUsers.docs}');
      users = allUsers.docs
          .map((e) => InviteUsers.fromJson(e.data() as Map<String, dynamic>))
          .toList();
      return users;
    } catch (e) {
      return users;
    }
  }

  Future<String> addUserEmail(Map<String, dynamic> userInfo) async {
    try {
      String adminId = await getAdminID();
      await adminRefCollection
          .doc(adminId.toString())
          .collection('invite')
          .doc(userInfo['email'])
          .set(userInfo);
      return 'success';
    } catch (e) {
      return 'error';
    }
  }
}
