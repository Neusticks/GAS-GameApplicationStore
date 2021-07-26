import 'package:flutter/material.dart';

import 'components/body.dart';

class IncomingRequestProductScreen extends StatelessWidget {
  static String routeName = "/incoming_request_product";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}