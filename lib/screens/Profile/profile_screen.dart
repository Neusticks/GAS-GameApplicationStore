import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/bottom_nav_bar_button.dart';

import '../../enums.dart';
import 'components/body.dart';
import '../../size_config.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
