import 'package:gas_gameappstore/screens/Chats/chat_screen.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:flutter/material.dart';
import 'product_images.dart';
import 'favorite_action.dart';
import 'package:logger/logger.dart';
import 'product_review.dart';

class Body extends StatelessWidget {
  final String productId;

  const Body({
    Key key,
    @required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data;
                return Column(
                  children: [
                    ProductImages(product: product),
                    SizedBox(height: getProportionScreenHeight(20)),
                    FavoriteAction(product: product),
                    SizedBox(height: getProportionScreenHeight(20)),
                    ProductReview(product: product),
                    SizedBox(height: getProportionScreenHeight(100)),

                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

