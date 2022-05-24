import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peas_cloud/views/auth/login_screen.dart';
import 'package:peas_cloud/views/main/main_screen.dart';
import 'config/constants.dart';
import 'config/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    userController.saveToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peas cloud',
      theme: lightTheme,
      home: auth.currentUser != null
          ?   MainScreen() :  LoginScreen(),
    );
  }
}


