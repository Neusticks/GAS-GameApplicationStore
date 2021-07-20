import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';

import 'components/body.dart';

class ManagePilotRequestScreen extends StatelessWidget {
  static String routeName = "/managepilotrequest";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilot Request List"),
      ),
      body: Body(),
    );
  }
}
