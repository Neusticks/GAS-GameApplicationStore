import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final String productId;

  const Body({
    Key key,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopRoundedContainer(
            color: Colors.white,
            child: FutureBuilder<Product>(
                future: ProductDatabaseHelper().getProductWithID(productId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final product = snapshot.data;
                    return Column(
                      children: [
                        ProductImages(product: product),
                        ProductDescription(
                          product: product,
                          pressOnSeeMore: () {},
                        ),
                        TopRoundedContainer(
                          color: Color(0xFFF6F7F9),
                          child: Column(
                            children: [
                              TopRoundedContainer(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.screenWidth * 0.15,
                                    right: SizeConfig.screenWidth * 0.15,
                                    bottom: getProportionScreenWidth(40),
                                    top: getProportionScreenWidth(15),
                                  ),
                                  child: DefaultButton(
                                    text: "Add To Cart",
                                    press: () async {
                                      bool addedSuccessfully = false;
                                      String snackbarMessage;
                                      try {
                                        addedSuccessfully =
                                            await UserDatabaseHelper().addProductToCart(productId);
                                        if (addedSuccessfully == true) {
                                          snackbarMessage = "Product added successfully";
                                        } else {
                                          throw "Coulnd't add product due to unknown reason";
                                        }
                                      } on FirebaseException catch (e) {
                                        Logger().w("Firebase Exception: $e");
                                        snackbarMessage = "Something went wrong";
                                      } catch (e) {
                                        Logger().w("Unknown Exception: $e");
                                        snackbarMessage = "Something went wrong";
                                      } finally {
                                        Logger().i(snackbarMessage);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(snackbarMessage),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                })),
      ],
    );
  }
}
