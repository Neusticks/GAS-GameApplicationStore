import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ManageAddressesScreen extends StatelessWidget {
  static String routeName = "/manageaddresses";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}