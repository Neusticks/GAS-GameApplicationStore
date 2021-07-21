import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Cart/cart_screen.dart';
import 'package:gas_gameappstore/screens/Transaction/transaction_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  final Function onSearchSubmitted;
  const HomeHeader({
    Key key,
    @required this.onSearchSubmitted,
  }) : super(key: key);

  Future<int> getTransaction() async {
    int size;
    await FirebaseFirestore.instance.collection("users").doc(AuthentificationService().currentUser.uid).collection("ordered_products").get().then((snap) => {
      size = snap.size,
    });
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            onSubmit: onSearchSubmitted,
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/shopping-cart.svg",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CartScreen();
            })),
          ),
          FutureBuilder(
            future: getTransaction(),
            builder: (context, snapshot){
              return IconBtnWithCounter(
                svgSrc: "assets/icons/Bell.svg",
                numOfItems: snapshot.data,
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                  return TransactionScreen();
                })),
              );
            }
          ),
        ],
      ),
    );
  }
}
