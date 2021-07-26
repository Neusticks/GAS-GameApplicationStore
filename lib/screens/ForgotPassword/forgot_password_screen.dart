import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/ForgotPassword/components/Background.dart';
import 'package:gas_gameappstore/size_config.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgotPassword";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Background(),
    );
  }
}
