import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/body.dart';
import 'package:gas_gameappstore/size_config.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      // Here i can use size.width but use double.infinity because both work as a same
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "Register Account",
                style: headingStyle,
              ),
              Text(
                "Complete your details or register \nwith social media",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionScreenHeight(30)),
              Body(),
              SizedBox(height: getProportionScreenHeight(20)),
              Text(
                "By continuing your confirm that you agree \nwith our Terms and Conditions",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionScreenHeight(20)),
            ],),
        )
      ),
    );
  }
}
