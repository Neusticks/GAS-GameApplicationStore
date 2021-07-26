import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';

import 'components/body.dart';

class ManageUserScreen extends StatelessWidget {
  static String routeName = "/manageuser";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text("User List"),
      ),
      body: Body(),
    );
  }
}
