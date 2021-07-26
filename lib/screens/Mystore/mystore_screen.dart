
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/bottom_nav_bar_button.dart';
import 'package:gas_gameappstore/enums.dart';
import 'package:gas_gameappstore/models/Store.dart';
import 'components/body.dart';
import '../../size_config.dart';

class MyStoreScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     'Store Profile',
        //     style: TextStyle(
        //     fontSize: 24.0,
        //     fontWeight: FontWeight.w300,
        //   ),
        // )
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.message),
    );
  }

}
