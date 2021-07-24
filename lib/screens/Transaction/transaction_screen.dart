import 'package:flutter/material.dart';

import 'components/body.dart';

class TransactionScreen extends StatelessWidget {
  static String routeName = "/favorite_product";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}