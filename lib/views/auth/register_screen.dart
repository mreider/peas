import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peas_cloud/views/auth/email_verification_screen.dart';
import 'package:peas_cloud/views/auth/login_screen.dart';
import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../main/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? password;
  String? conform_password;
  bool remember = false;
  final List<String> errors = [];


  void addError({String? error}) {
    if (!errors.contains(error))
     // setState(() {
        errors.add(error!);
     // });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
     // setState(() {
        errors.remove(error);
     // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.5),
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: CustomSurffixIcon(
                                  svgIcon:
                                  'assets/icons/logo.png',
                                  size: 110,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25, right: 25, top: 10),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      title('Full Name'),
                                      TextFormField(
                                        controller: nameController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.name,
                                        onSaved: (newValue) => name = newValue,
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            removeError(error: kNameNullError);
                                          }
                                          return null;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            addError(error: kNameNullError);
                                            return kNameNullError;
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color:
                                              Colors.grey[400]),
                                          errorStyle: TextStyle(color: Colors.pink),
                                          //  contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(12),
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                                          ),
                                          hintText: 'Your Name',

                                          //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                                        ),
                                      ),
                                      title('Email'),
                                      buildEmailFormField(),
                                      title('Password'),
                                      buildPasswordFormField(),
                                     // title('Confirm Password'),
                                    //  buildConformPassFormField(),
                                      SizedBox(height: 5),
                                      DefaultButton(
                                        title: "Register",
                                        press: () async {
                                          if (_formKey.currentState!.validate()) {
                                            _formKey.currentState!.save();
                                            await showLoaderDialog(context, 'Please wait...');
                                            print('email- $email');
                                            print('password- $password');
                                            String resp = await authController.signUpUser(email!, password! , name! , context);

                                            print('resp_value - ${resp}');
                                            if (resp == 'success') {
                                              if(auth.currentUser!.emailVerified){
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => MainScreen()),
                                                        (Route<dynamic> route) => false);
                                              }else{

                                                Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => EmailVerificationScreen(user: auth!.currentUser!,)),
                                                        (Route<dynamic> route) => false);
                                              }

                                            } else {
                                              print('else');
                                              Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(resp),
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
                                            // if all are valid then go to success screen
                                            //  Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Get.to(LoginScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: GoogleFonts.inter(
                                        color: kDarkBlack,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(LoginScreen());
                                      },
                                      child: Text(
                                        ' LogIn ',
                                        style: GoogleFonts.inter(
                                          color: kColorPrimary,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              GestureDetector(

                                onTap: () async {

                                },
                                child: Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'By continuing, you indicate that you have read \nand agree to our ',
                                          style: GoogleFonts.inter(
                                            //decoration: TextDecoration.underline,
                                            color: kDarkBlack,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Terms and Conditions. ',
                                              style: GoogleFonts.inter(
                                                decoration:
                                                TextDecoration.underline,
                                                color: kColorPrimary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            // can add more TextSpans here...
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }


  TextFormField buildConformPassFormField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: new InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: TextStyle(
            color:
            Colors.grey[400]),
        errorStyle: TextStyle(color: Colors.pink),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(12),
            borderSide: BorderSide(
                color: Colors.grey,
                width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        hintText: 'Re-enter your password', //add color
      ),
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 5) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return kPassNullError;
        } else if (value!.length < 5) {
          addError(error: kShortPassError);
          return kShortPassError;
        }
        return null;
      },
      decoration: new InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: TextStyle(
            color:
            Colors.grey[400]),
        errorStyle: TextStyle(color: Colors.pink),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey,
                width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        hintText: 'Your Password', //add color
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: new InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: TextStyle(
            color:
            Colors.grey[400]),
        errorStyle: TextStyle(color: Colors.pink),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(12),
            borderSide: BorderSide(
                color: Colors.grey,
                width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        hintText: 'yourmail@domain.com',
      ),
    );
  }
}
