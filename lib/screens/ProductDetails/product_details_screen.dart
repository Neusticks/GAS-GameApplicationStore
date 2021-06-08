import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/ProductDetails/provider_models/product_actions.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';
import 'components/add_to_cart.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  static String routeName = "/details";

  const ProductDetailsScreen({
    Key key,
    @required this.productId,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context).settings.arguments;
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F6F9),
        ),
        body: Body(
          productId: productId,
        ),
        floatingActionButton: AddToCart(productId: productId),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }
}

// class ProductDetailsArguments {
//   final Product product;

//   ProductDetailsArguments({@required this.product});
// }