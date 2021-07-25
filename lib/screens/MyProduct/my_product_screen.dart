import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class MyProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     'Your Product',
        //     style: TextStyle(
        //     fontSize: 24.0,
        //     fontWeight: FontWeight.w300,
        //   ),
        // )
      ),
      body: Body(),
      //body: Body(),
    );
  }
}
