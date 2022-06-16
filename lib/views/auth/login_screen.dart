import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../main/main_screen.dart';
import 'email_verification_screen.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;
  bool loading = false;
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
      //  setState(() {
      errors.remove(error!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: CustomSurffixIcon(
                                  svgIcon: 'assets/icons/logo.png',
                                  size: 110,
                                ),
                              ),
                              title('Email'),
                              buildEmailFormField(),
                              SizedBox(height: 5),
                              title('Password'),
                              buildPasswordFormField(),
                              SizedBox(height: 5),
                              DefaultButton(
                                  title: 'LogIn',
                                  press: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await showLoaderDialog(
                                          context, 'Please wait...');
                                      String resp = await authController
                                          .signInUser(email!, password!);
                                      if (resp == 'success') {
                                        if (auth.currentUser!.emailVerified) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              MainScreen()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        } else {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EmailVerificationScreen(
                                                            user: auth
                                                                .currentUser!,
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }
                                      } else {
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
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange[800]),
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    }
                                  }),
                              GestureDetector(
                                onTap: () {
                                  Get.to(RegisterScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: GoogleFonts.inter(
                                        color: kDarkBlack,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(RegisterScreen());
                                      },
                                      child: Text(
                                        ' Register ',
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return ResetPasswordScreen();
                                      }));
                                    },
                                    child: Text(
                                      "Reset Password?",
                                      style: GoogleFonts.inter(
                                        color: kDarkBlack,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'By continuing, you indicate that you have read \nand agree to our ',
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
                              decoration: TextDecoration.underline,
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
              )
            ],
          ),
        ));
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
        } else if (value.length < 5) {
          addError(error: kShortPassError);
          return kShortPassError;
        }
        return null;
      },
      decoration: new InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[400]),
        errorStyle: TextStyle(color: Colors.pink),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
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
      decoration: InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[400]),
        errorStyle: const TextStyle(color: Colors.pink),
        //  contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
        hintText: 'yourmail@domain.com',
      ),
    );
  }
}
