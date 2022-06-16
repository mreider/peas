import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$");

const String kNameNullError = 'Please Enter your full name. Example: "Anna Polski"';
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password should be 6 digits";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

//Firestore database configure files
final storeRefCollection = FirebaseFirestore.instance.collection('users');
final adminRefCollection = FirebaseFirestore.instance.collection('admin');
final auth = FirebaseAuth.instance;

//services
AuthController authController = AuthController();
UserController userController = UserController();



showAlertDialog(BuildContext context , text){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text(text),
                actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        child: Text(
                            'OK',
                            style: TextStyle(color: Colors.orange[800]),
                        ),
                    )
                ],
            );
        });
}

//Show loading bar
showLoaderDialog(BuildContext context, text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
            return SimpleDialog(
                children: [
                    Center(
                        child: Column(
                            children: [
                                CupertinoActivityIndicator(
                                    animating: true,
                                ),
                                Text(text)
                            ],
                        ),
                    )
                ],
            );
        });
}


Widget title(String text) {
    return Padding(
        padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 0,
            right: 30,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Text(
                    text,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //add color
                ),
            ],
        ),
    );
}



