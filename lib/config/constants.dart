import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/default_button.dart';
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
const String kShortPassError = "Password should be 8 digits";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

//Firestore database configure files
final storeRefCollection = FirebaseFirestore.instance.collection('users');
final auth = FirebaseAuth.instance;

//services
AuthController authController = AuthController();
UserController userController = UserController();



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
            left: 30,
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

