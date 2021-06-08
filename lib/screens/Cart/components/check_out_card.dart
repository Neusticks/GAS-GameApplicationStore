  
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gas_gameappstore/components/default_button.dart';

// import '../../../constants.dart';
// import '../../../size_config.dart';

// class CheckoutCard extends StatelessWidget {
//   final VoidCallback onCheckoutPressed;
//   const CheckoutCard({
//     Key key,
//     @required this.onCheckoutPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: getProportionScreenWidth(15),
//         horizontal: getProportionScreenWidth(30),
//       ),
//       // height: 174,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -15),
//             blurRadius: 20,
//             color: Color(0xFFDADADA).withOpacity(0.15),
//           )
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   height: getProportionScreenWidth(40),
//                   width: getProportionScreenWidth(40),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F6F9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: SvgPicture.asset("assets/icons/receipt.svg"),
//                 ),
//                 Spacer(),
//                 Text("Add voucher code"),
//                 const SizedBox(width: 10),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 12,
//                   color: kTextColor,
//                 )
//               ],
//             ),
//             SizedBox(height: getProportionScreenHeight(20)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                     text: "Total:\n",
//                     children: [
//                       TextSpan(
//                         text: "\$337.15",
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: getProportionScreenWidth(190),
//                   child: DefaultButton(
//                     text: "Check Out",
//                     press: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  final VoidCallback onCheckoutPressed;
  const CheckoutCard({
    Key key,
    @required this.onCheckoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDADADA).withOpacity(0.6),
            offset: Offset(0, -15),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<num>(
                  future: UserDatabaseHelper().cartTotal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cartTotal = snapshot.data;
                      return Text.rich(
                        TextSpan(text: "Total\n", children: [
                          TextSpan(
                            text: "${rupiah(cartTotal)}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  width: getProportionScreenWidth(190),
                  child: DefaultButton(
                    text: "Checkout",
                    press: onCheckoutPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
