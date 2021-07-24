import 'package:flutter/material.dart';

import 'components/body.dart';

class StoreInformationScreen extends StatelessWidget {
  static String routeName = "/storeinfo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Account"),
      ),
      body: Body(),
    );
  }
}