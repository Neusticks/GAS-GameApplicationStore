import 'package:flutter/material.dart';

import 'components/body.dart';

class TransactionHistoryScreen extends StatelessWidget {
  static String routeName = "/transaction_history";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}