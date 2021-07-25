import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';

class Loading extends StatelessWidget{
  const Loading();

  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}