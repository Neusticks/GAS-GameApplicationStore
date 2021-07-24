import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';

import 'components/body.dart';

class PilotRequestListScreen extends StatelessWidget {
  static String routeName = "/pilotrequestlist";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
      ),
      body: Body(),
    );
  }
}
