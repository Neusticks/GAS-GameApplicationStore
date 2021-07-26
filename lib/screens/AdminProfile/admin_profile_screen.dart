import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import '../../size_config.dart';

class AdminProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     "Profile",
        //     style: TextStyle(
        //     fontSize: 24.0,
        //     fontWeight: FontWeight.w300,
        //   ),
        // )
      ),
      body: Body(),
    );
  }
}
