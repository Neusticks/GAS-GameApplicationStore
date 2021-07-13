import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/GameNews/game_news_screen.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(getProportionScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionScreenWidth(20),
        vertical: getProportionScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "Game News",
              style: TextStyle(
                fontSize: getProportionScreenWidth(24),
                fontWeight: FontWeight.bold,
                
              ),
              recognizer: new TapGestureRecognizer()..onTap = (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GameNewsScreen();
                  }));
              }
            ),
            
          ],
        ),
      ),
    );
  }
}