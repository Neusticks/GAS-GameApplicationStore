import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'components/body.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = "/ChangePasswordScreen";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
