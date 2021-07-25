// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gas_gameappstore/constants.dart';
// import 'package:gas_gameappstore/size_config.dart';

// import '../../../models/Product.dart';
// import 'product_images.dart';

// class ProductDescription extends StatelessWidget {
//   const ProductDescription({
//     Key key,
//     @required this.product,
//     @required this.pressOnSeeMore,
//   }) : super(key: key);

//   final Product product;
//   final GestureTapCallback pressOnSeeMore;

//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(padding: 
//           EdgeInsets.symmetric(horizontal: getProportionScreenWidth(20)),
//         child: Text(
//             product.productName,
//             style: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Container(
//             padding: EdgeInsets.all(getProportionScreenWidth(15)),
//             width: getProportionScreenWidth(64),
//             decoration: BoxDecoration(
//               color: product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               )
//             ),
//             child: SvgPicture.asset(
//               "assets/icons/Heart Icon_2.svg",
//               color: product.isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
//             )
//           )
//         ),
//         Padding(
//           padding: EdgeInsets.only(
//             left: getProportionScreenWidth(20),
//             right: getProportionScreenWidth(64),
//           ),
//           child: Text(
//             product.productDescription,
//             maxLines: 3,
//           )
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionScreenWidth(20),
//             vertical: 10,
//           ),
//           child: GestureDetector(
//             onTap: pressOnSeeMore,
//             child: Row(
//               children: [
//                 Text(
//                   "See More Detail",
//                   style: TextStyle(
//                     color: kPrimaryColor, fontWeight: FontWeight.w600
//                   ),
//                 ),
//                 SizedBox(width: 5),
//                 Icon(Icons.arrow_forward_ios, size: 12, color: kPrimaryColor)
//               ]
//             )
//           )
//         )
//       ],
//     );
//   }
// }

import 'package:gas_gameappstore/screens/Chats/chat_screen.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:indonesia/indonesia.dart';

import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: product.productName,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "\n${product.productVariant} ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: getProportionScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text.rich(
                      TextSpan(
                        text: "${rupiah(product.productDiscountPrice)}\n",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                        children: [
                          TextSpan(
                            text: "${rupiah(product.productOriginalPrice.toInt())}\n",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
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
                          "assets/icons/Discount.svg",
                          color: kPrimaryColor,
                        ),
                        Center(
                          child: Text(
                            "${product.calculatePercentageDiscount()}%\nOff",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionScreenHeight(15),
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
            const SizedBox(height: 16),
            ExpandableText(
              title: "Highlights",
              content: product.productHighlights,
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Description",
              content: product.productDescription,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Sold by ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "${product.sellerId}",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: ()=>
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ChatScreen(peerId: product.ownerId);
                    })), child: Text('Chat'))
          ],
        ),
      ],
    );
  }
}
