import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/HomePage/Components/background.dart';
import 'package:gas_gameappstore/screens/HomePage/Components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
