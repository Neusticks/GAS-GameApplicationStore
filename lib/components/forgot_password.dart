import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';

class ForgotPassword extends StatelessWidget {
  final Function press;
  const ForgotPassword({
    Key key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Forgot Password ? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
           "Click Here!",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}