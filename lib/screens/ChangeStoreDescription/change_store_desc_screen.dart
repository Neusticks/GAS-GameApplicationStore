  
import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ChangeStoreDescScreen extends StatelessWidget {
  static String routeName = "/changestoredesc";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}