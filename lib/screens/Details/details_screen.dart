import 'package:flutter/material.dart';

import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  final String productId;
  static String routeName = "/details";

  const DetailsScreen({
    Key key,
    @required this.productId,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      // appBar: CustomAppBar(rating: agrs.product.productRating),
      body: Body( productId: productId),
    );
  }
}

// class ProductDetailsArguments {
//   final Product product;

//   ProductDetailsArguments({@required this.product});
// }