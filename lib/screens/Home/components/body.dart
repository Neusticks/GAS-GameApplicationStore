import 'package:flutter/material.dart';
import 'package:gas_gameappstore/size_config.dart';


import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionScreenWidth(10)),
            DiscountBanner(),
            Categories(),
            SpecialOffers(),
            SizedBox(height: getProportionScreenWidth(30)),
            PopularProducts(),
            SizedBox(height: getProportionScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}