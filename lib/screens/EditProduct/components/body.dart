
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'edit_product_form.dart';

class Body extends StatelessWidget {
  final Product productToEdit;

  const Body({Key key, this.productToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionScreenHeight(10)),
                Text(
                  "Fill Product Details",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionScreenHeight(30)),
                EditProductForm(product: productToEdit),
                SizedBox(height: getProportionScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
