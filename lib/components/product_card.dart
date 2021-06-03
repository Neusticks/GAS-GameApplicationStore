// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gas_gameappstore/models/Product.dart';
// import 'package:gas_gameappstore/screens/details/details_screen.dart';

// import '../constants.dart';
// import '../size_config.dart';

// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     Key key,
//     this.width = 140,
//     this.aspectRetio = 1.02,
//     @required this.product,
//   }) : super(key: key);

//   final double width, aspectRetio;
//   final Product product;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: getProportionScreenWidth(20)),
//       child: SizedBox(
//         width: getProportionScreenWidth(width),
//         child: GestureDetector(
//           onTap: () => Navigator.pushNamed(
//             context,
//             DetailsScreen.routeName,
//             arguments: ProductDetailsArguments(product: product),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AspectRatio(
//                 aspectRatio: 1.02,
//                 child: Container(
//                   padding: EdgeInsets.all(getProportionScreenWidth(20)),
//                   decoration: BoxDecoration(
//                     color: kSecondaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Hero(
//                     tag: product.id.toString(),
//                     child: Image.asset(product.productImages[0]),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 product.productName,
//                 style: TextStyle(color: Colors.black),
//                 maxLines: 2,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "\$${product.productOriginalPrice}",
//                     style: TextStyle(
//                       fontSize: getProportionScreenWidth(18),
//                       fontWeight: FontWeight.w600,
//                       color: kPrimaryColor,
//                     ),
//                   ),
//                   InkWell(
//                     borderRadius: BorderRadius.circular(50),
//                     onTap: () {},
//                     child: Container(
//                       padding: EdgeInsets.all(getProportionScreenWidth(8)),
//                       height: getProportionScreenWidth(28),
//                       width: getProportionScreenWidth(28),
//                       decoration: BoxDecoration(
//                         color: product.isFavourite
//                             ? kPrimaryColor.withOpacity(0.15)
//                             : kSecondaryColor.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/Heart Icon_2.svg",
//                         color: product.isFavourite
//                             ? Color(0xFFFF4848)
//                             : Color(0xFFDBDEE4),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';
import 'package:pecahan_rupiah/pecahan_rupiah.dart';
import '../constants.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final GestureTapCallback press;
  const ProductCard({
    Key key,
    @required this.productId,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Product product = snapshot.data;
                return buildProductCardItems(product);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
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

  Column buildProductCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              product.productImages[0],
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  "${product.productName}\n",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text.rich(
                        TextSpan(
                          //text: "\R\p.${product.productDiscountPrice}\n",
                          text: "${Pecahan.rupiah(value: product.productDiscountPrice.toInt(), withRp: true).toString()}\n",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              // text: "\R\p.${product.productOriginalPrice}",
                              text: "${Pecahan.rupiah(value: product.productOriginalPrice.toInt(), withRp: true).toString()}\n",
                              style: TextStyle(
                                color: kTextColor,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/DiscountTag.svg",
                            color: kPrimaryColor,
                          ),
                          Center(
                            child: Text(
                              "${product.calculatePercentageDiscount()}%\nOff",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
