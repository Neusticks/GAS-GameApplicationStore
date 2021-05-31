import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/Cart.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(cart.id),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Row(
            children: [
              SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(getProportionScreenWidth(10)),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(snapshot.data.productImages[0]),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data.productName,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "\$${snapshot.data.productOriginalPrice}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: kPrimaryColor),
                      children: [
                        TextSpan(
                            text: " x${cart.itemQty}",
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.hasError){
          final error = snapshot.error;
          Logger().w(error.toString());
          return Center(
            child: Text(
              error.toString(),
            )
          );
        }else{
          return Center(
            child: Icon(
              Icons.error,
            )
          );
        }
      }
    );
  }
}