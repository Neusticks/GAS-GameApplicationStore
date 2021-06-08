import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/screens/AccountInformation/account_information.dart';
import 'package:gas_gameappstore/screens/Profile/profile_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/welcome_screen.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/models/Users/services.dart';
import 'package:gas_gameappstore/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: theme(),
      home: SplashScreen(),
    );
  }
}
