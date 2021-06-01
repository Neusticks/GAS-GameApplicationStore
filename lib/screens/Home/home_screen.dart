import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/components/bottom_nav_bar_button.dart';

import '../../enums.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/HomeScreen";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
