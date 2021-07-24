import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/PilotRequestList/manage_pilot_screen.dart';
import 'package:gas_gameappstore/screens/PilotService/pilot_service_screen.dart';
import 'package:gas_gameappstore/screens/ReportProblem/report_problem_screen.dart';
import 'package:gas_gameappstore/screens/ReportUser/report_user_screen.dart';
import 'package:gas_gameappstore/screens/Settings/profile_settings.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

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
            "Profile",
            style: headingStyle,
          ),
          SizedBox(height: getProportionScreenHeight(20)),
          PilotProfilePic(),
          SizedBox(height: 30),
          PilotProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileSettings();
                  }))
          ),
          // ProfileMenu(
          //   text: "Notifications",
          //   icon: "assets/icons/Bell.svg",
          //   press: () {},
          // ),
          PilotProfileMenu(
            text: "Pilot Request List",
            icon: "assets/icons/User Icon.svg",
            press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
              return PilotRequestListScreen();
            })),
          ),
          PilotProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async{
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: _signOut,
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () async{
                        Navigator.pop(context, 'No');
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

}
