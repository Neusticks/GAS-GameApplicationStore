import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../game_news_menu.dart';


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
          SizedBox(height: 20),
          GameNewsMenu(
              text: "Epic Seven",
              icon: "assets/icons/epicseven.svg",
              press: () async => launch('https://page.onstove.com/epicseven/global')
              
              
          ),
          GameNewsMenu(
            text: "Dota 2",
            icon: "assets/icons/dota2.svg",
            press: () async => launch('https://www.dota2.com/patches')
          ),
          // GameNewsMenu(
          //   text: "Help Center",
          //   icon: "assets/icons/Question mark.svg",
          //   press: () {},
          // ),
          // GameNewsMenu(
          //   text: "Log Out",
          //   icon: "assets/icons/Log out.svg",
          //   press: () {
          //     _signOut();
          //   },
          // ),
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
