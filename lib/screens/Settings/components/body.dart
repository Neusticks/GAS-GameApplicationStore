import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/AccountInformation/account_information.dart';
import 'package:gas_gameappstore/screens/ChangePassword/change_password_screen.dart';
import 'package:gas_gameappstore/screens/ManageAddresses/manage_addresses_screen.dart';
import 'package:gas_gameappstore/screens/profile/components/profile_menu.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            "My Account",
            style: headingStyle,
          ),
          SizedBox(height: getProportionScreenHeight(20)),
          SizedBox(height: 20),
          // ProfileMenu(
          //   text: "Create Store",
          //   icon: "assets/icons/game-store.svg",
          //   press: () =>

          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return AccountInformationScreen();
          //       })),
                  
          // ),
          ProfileMenu(
            text: "Account Information",
            icon: "assets/icons/User Icon.svg",
            press: () =>

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AccountInformationScreen();
                })),
                  
          ),
          ProfileMenu(
            text: "My Address",
            icon: "assets/icons/Location point.svg",
            press: () => 
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ManageAddressesScreen();
                  })),
          ),
          ProfileMenu(
            text: "Change Password",
            icon: "assets/icons/Lock.svg",
            press: () => 
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangePasswordScreen();
                  })),
          ),
        ],
      ),
    );
  }
}