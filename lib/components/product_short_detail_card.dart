import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:indonesia/indonesia.dart';

import '../constants.dart';
import '../size_config.dart';
import 'package:pecahan_rupiah/pecahan_rupiah.dart';

class ProductShortDetailCard extends StatelessWidget {
  final String productId;
  final VoidCallback onPressed;
  const ProductShortDetailCard({
    Key key,
    @required this.productId,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Row(
              children: [
                SizedBox(
                  width: getProportionScreenWidth(88),
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: snapshot.data.productImages.length > 0
                          ? Image.network(
                        product.productImages[0],
                        fit: BoxFit.contain,
                      )
                          : Text("No Image"),
                    ),
                  ),
                ),
                SizedBox(width: getProportionScreenWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                            text: "${rupiah(product.productDiscountPrice)}",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: "${rupiah(product.productOriginalPrice)}",
                                style: TextStyle(
                                  color: kTextColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
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
    );
  }
}