import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peas_cloud/config/colors.dart';
import 'package:peas_cloud/views/auth/login_screen.dart';
import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../components/defualt_headertext.dart';
import '../../config/constants.dart';

class ResetPasswordScreen extends StatefulWidget {


  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool isSent = false;

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
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

            backgroundColor: kColorPrimary,
            //  centerTitle: true,
            title: Text('Re-set Password' , style: TextStyle(color: kWhite),)
        ),
      body: isSent? Column(
        children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CustomSurffixIcon(
              svgIcon: 'assets/icons/logo.png',
              size: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: DefaultHeaderTitle(title: 'Check your Email'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 40),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'An email has bees sent to your account\'s email address ${email}. Please check your email to continue',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black54)),
              ]),
            ),
          ),
          Image.asset(
            'assets/confirm.png',
            height: 120,
          ),
        ],
      ) : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: CustomSurffixIcon(
                  svgIcon: 'assets/icons/logo.png',
                  size: 110,
                ),
              ),
              SizedBox(height: 30),
              Text('Send a password reset link'  , style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: kColorPrimary
              ),),
              SizedBox(height: 10),
              title('Email'),
              buildEmailFormField(),
              SizedBox(height: 30),
              DefaultButton(
                  title: 'Send',
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      //await showLoaderDialog(context, 'Please wait...');
                      print('email_ $email');
                      await auth.sendPasswordResetEmail(email: email!).then((val){

                        setState(() {
                          isSent = true;
                        });
                      }).whenComplete(() {
                        print('sent');
                        // Navigator.pop(context, true);
                        // if (isLoading) {
                        setState(() {
                          isSent = true;
                        });
                        // }
                      }).catchError((error) {
                        setState(() {
                          isSent = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Something went to wrong. Please try with your register email.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      });
                    }
                  }),
            ],
          ),
        ),
      )
    );
  }


  Widget buildEmailFormField() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
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
              color: Colors.grey[400]),
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
          hintText: 'yourmail@domain.com',
        ),
      ),
    );
  }
}
