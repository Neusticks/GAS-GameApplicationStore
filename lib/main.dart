import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/ManageUserAdmin/manage_user_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/welcome_screen.dart';
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
      home: ManageUserScreen(),
    );
  }
}
