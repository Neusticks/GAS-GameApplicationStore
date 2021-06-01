import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/Settings/profile_settings.dart';
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
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileSettings();
                  }))
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              _signOut();
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
