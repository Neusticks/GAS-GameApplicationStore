import 'package:flutter/cupertino.dart';

import 'Body.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Background extends StatelessWidget{

  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text("Forgot Password", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Body(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}