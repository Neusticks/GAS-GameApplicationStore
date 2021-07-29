import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/PilotProfile/profile_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/Components/body.dart';
import 'package:gas_gameappstore/size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/welcome";
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, route);
  }

  route() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) async{
          final userDocRef = await FirebaseFirestore.instance.collection("users").where(FieldPath.documentId, isEqualTo: user.uid).get();
          final userDocRefSnapshot = userDocRef.docs.single;

      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else if(userDocRefSnapshot.data()["userRole"] != "Pilot"){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PilotProfileScreen()));
      }
    });
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
