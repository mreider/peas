import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../components/defualt_headertext.dart';
import '../../config/colors.dart';
import '../main/main_screen.dart';

class EmailVerificationScreen extends StatefulWidget {

  final User user;

  EmailVerificationScreen({ required this.user});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();

}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  Timer? timer;

  @override
  void initState() {
    super.initState();

    print(widget.user.email.toString());
    widget.user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkEmailVerified();
    });
  }


  Future<void> _checkEmailVerified() async {
    await widget.user.reload();
    if (widget.user.emailVerified) {
      timer!.cancel();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => MainScreen()),
              (Route<dynamic> route) => false);
    }

    print(widget.user.email);
    print(widget.user.emailVerified);

  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kColorPrimary,
            //  centerTitle: true,
            title: Text('Confirmation Screen' , style: TextStyle(color: kWhite),)
        ),
        body: Column(
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
                text: TextSpan(
                    children: [
                  TextSpan(
                      text: 'Please check your inbox for a registration confirmation.',
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

            SizedBox(height: 20,),

            DefaultButton(press: _checkEmailVerified, title: "Retry"),

          ],
        )
    );
  }
}
