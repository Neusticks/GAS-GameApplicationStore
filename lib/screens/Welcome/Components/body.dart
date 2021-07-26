import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/screens/Welcome/Components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gas_gameappstore/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: getProportionScreenHeight(10)),
            Align(
              alignment: Alignment.center,
              child: Text(
                "WELCOME TO GAS",
                style: headingStyle,
              ),
            ),
            SizedBox(height: getProportionScreenHeight(100)),
            SvgPicture.asset(
            "assets/icons/game-store.svg",
            height: getProportionScreenHeight(265),
            ),
            SizedBox(height: getProportionScreenHeight(300) ),
          ],
        ),
      ),
    );
  }
}
