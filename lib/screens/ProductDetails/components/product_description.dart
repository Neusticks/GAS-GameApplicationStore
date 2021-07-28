
import 'package:cloud_firestore/cloud_firestore.dart';
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
                      showPrice(product)
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: showDiscountRateField(product)
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
              child: Text('Chat with Seller'),
                onPressed: ()=> chatUserButtonCallback(product.ownerId, context),),
          ],
        ),
      ],
    );
  }

  TextSpan showPrice(Product product){
    if(product.productOriginalPrice.toInt() == product.productDiscountPrice.toInt()){
      return TextSpan(
        text: "${rupiah(product.productDiscountPrice.toInt())} ",
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      );
    }
    else{
      return TextSpan(
          text: "${rupiah(product.productDiscountPrice.toInt())}\n",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          children: [
            TextSpan(
              text: "${rupiah(product.productOriginalPrice.toInt())}",
              style: TextStyle(
                color: kTextColor,
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ]
      );
    }
  }

  Stack showDiscountRateField(Product product){
    final discountRate = product.calculatePercentageDiscount();
    if(discountRate == 0) return Stack();
    else {
      return Stack(
        children: [
          SvgPicture.asset(
            "assets/icons/DiscountTag.svg",
            color: kPrimaryColor,
          ),
          Center(
              child: showDiscountRate(product)
          ),
        ],
      );
    }
  }

  Text showDiscountRate(Product product){
    final discountRate = product.calculatePercentageDiscount();
    if(discountRate == 0){
      return null;
    }else return Text(
      "${product.calculatePercentageDiscount()}%\nOff",
      style: TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> chatUserButtonCallback(requestOwnerId, context) async{
    final requestDocSnapshot = await FirebaseFirestore.instance.collection('users').doc(requestOwnerId).get();
    final Map<String, dynamic> docFields = requestDocSnapshot.data();
    String avatar = docFields['userProfilePicture'].toString();
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ChatScreen(peerId: requestOwnerId, peerAvatar: avatar);
    }));
  }
}
