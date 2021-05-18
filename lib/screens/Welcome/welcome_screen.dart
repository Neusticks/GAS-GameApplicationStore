import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/Components/body.dart';
import 'package:gas_gameappstore/size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/welcome";
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
