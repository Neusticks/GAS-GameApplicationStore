import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import '../../size_config.dart';

class GameNewsScreen extends StatelessWidget {
  static String routeName = "/gamenews";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(elevation: 0.0,
      ),
      body: Body(),
    );
  }
}
