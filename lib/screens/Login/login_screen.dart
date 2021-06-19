import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/Components/background.dart';
import 'package:gas_gameappstore/size_config.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Background(),
    );
  }
}
