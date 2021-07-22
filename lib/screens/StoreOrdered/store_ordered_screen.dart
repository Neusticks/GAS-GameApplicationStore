import 'package:flutter/material.dart';

import 'components/body.dart';


class StoreOrderedScreen extends StatelessWidget {
  static String routeName = "/store_ordered_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}