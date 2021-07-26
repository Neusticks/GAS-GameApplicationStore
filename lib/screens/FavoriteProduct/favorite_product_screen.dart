import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/bottom_nav_bar_button.dart';
import 'package:gas_gameappstore/enums.dart';

import 'components/body.dart';

class FavoriteProductScreen extends StatelessWidget {
  static String routeName = "/favorite_product";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.favourite),
    );
  }
}