import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class RegisterPilotServiceScreen extends StatelessWidget {
  static String routeName = "/registerpilotservice";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}