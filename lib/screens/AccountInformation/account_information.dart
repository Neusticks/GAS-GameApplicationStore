import 'package:flutter/material.dart';

import 'components/body.dart';

class AccountInformationScreen extends StatelessWidget {
  static String routeName = "/accountinformation";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: Body(),
    );
  }
}