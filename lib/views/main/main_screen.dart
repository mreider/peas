import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peas_cloud/config/constants.dart';
import 'package:peas_cloud/models/userDetails.dart';
import 'package:peas_cloud/views/auth/login_screen.dart';
import '../../components/custom_surfix_icon.dart';
import '../../config/colors.dart';
import '../../controllers/auth_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        //  centerTitle: true,
          title: Text( 'Profile' , style: TextStyle(color: kWhite),)
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
              future: userController.getUserById(auth.currentUser!.uid),
              builder: (context, AsyncSnapshot<UserDetails> snap) {
                if (snap.connectionState == ConnectionState.done && snap.hasData) {
                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 0.0),
                       child: CustomSurffixIcon(
                         svgIcon: 'assets/icons/logo.png',
                         size: 100,
                       ),
                     ),

                     Text(snap.data!.name,
                         style: GoogleFonts.inter(
                             fontWeight: FontWeight.w500,
                             fontSize: 18,
                             color: kDarkBlack)),
                     SizedBox(height: 40,),
                     MaterialButton(
                       color: kColorPrimary,
                         onPressed: () async{
                       await AuthController().signOut();
                       Navigator.of(context).pushAndRemoveUntil(
                           MaterialPageRoute(
                               builder: (context) => LoginScreen()),
                               (Route<dynamic> route) => false);
                     }, child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Text('Log out', maxLines: 2,
                           overflow: TextOverflow.clip,
                           style: GoogleFonts.inter(
                             color: kWhite,
                             fontWeight: FontWeight.w500,
                             fontSize: 16,
                           )),
                     ))

                   ],
                 );
                } else if (!snap.hasData || snap.hasError) {
                  return Center(child: CupertinoActivityIndicator(
                    animating: true,
                  ),);
                } else {
                  return Center(child: CupertinoActivityIndicator(
                    animating: true,
                  ),);
                }
              }),
        ),
      ),
    );
  }
}
