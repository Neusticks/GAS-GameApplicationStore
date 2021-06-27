

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/MyStore/components/mystore_menu.dart';
import 'package:gas_gameappstore/screens/Mystore/components/shop_pic.dart';
import 'package:gas_gameappstore/screens/Settings/profile_settings.dart';


class MyStore extends StatefulWidget {
  @override
  _MyStore createState() => _MyStore();
}

class _MyStore extends State<MyStore> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ShopPic(),
          SizedBox(height: 20),
          MyStoreMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileSettings();
                  }))
          ),
          MyStoreMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          MyStoreMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          MyStoreMenu(
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
