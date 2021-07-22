

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/MyProduct/my_product_screen.dart';
import 'package:gas_gameappstore/screens/MyStore/components/shop_pic.dart';
import 'package:gas_gameappstore/screens/Settings/profile_settings.dart';
import 'package:gas_gameappstore/screens/StoreOrdered/store_ordered_screen.dart';

import 'mystore_menu.dart';


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
          ShopPic(),
          SizedBox(height: 20),
          MyStoreMenu(
              text: "Store Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileSettings();
                  }))
          ),
          MyStoreMenu(
            text: "Ordered Product",
            icon: "assets/icons/receipt.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StoreOrderedScreen();
              }));
            },
          ),
          MyStoreMenu(
            text: "My Product",
            icon: "assets/icons/empty_box.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return MyProductsScreen();
              }));
            },
          ),
        ],
      ),
    );
  }

}
