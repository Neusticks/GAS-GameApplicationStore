  
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/Cart.dart';
import 'package:gas_gameappstore/screens/Cart/cart_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:pay/pay.dart';
import '../../../size_config.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class CheckoutCard extends StatelessWidget {
  //final _paymentItems = <PaymentItem>[];
  final VoidCallback onCheckoutPressed;

  CheckoutCard({
    Key key,
    @required this.onCheckoutPressed,
  }) : super(key: key);

  // @override
  // CheckoutCardState createState() => CheckoutCardState();
//}

//class CheckoutCardState extends State<CheckoutCard>{

  // Future<void> _pay() async {
  //   await InAppPayments.setSquareApplicationId(
  //       'sandbox-sq0idb-_F5YicVyQRFBdw0P2orLKA');
  //   InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: onCardNonceRequestSuccess, onCardEntryCancel: onCardEntryCancel);
  // }
  //
  // void onCardEntryCancel(){
  //   showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: const Text('Cancelled'),
  //         content: const Text('Input card credential has been cancelled!'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, 'OK'),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //   );
  // }
  //
  // void onCardNonceRequestSuccess(CardDetails result){
  //   print(result.nonce);
  //   //chargeCard(result);
  //
  //   InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
  // }
  //
  // void onCardEntryComplete() async{
  //   //Success, clear cart
  //   await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text('Success!'),
  //       content: const Text('Your order has been paid!'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () async{
  //             await FirebaseFirestore.instance.collection('users').doc(AuthentificationService().currentUser.uid).collection('cart').get().then((snapshot) {
  //               for (DocumentSnapshot ds in snapshot.docs){
  //                 ds.reference.delete();
  //               }
  //             });
  //             Navigator.pop(context, 'OK');
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                StreamBuilder(
                  stream: UserDatabaseHelper().cartTotal.asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cartTotal = snapshot.data;
                      //_paymentItems.add(PaymentItem(amount: cartTotal.toString(), label: "GAS Product", status: PaymentItemStatus.final_price));
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
                  // child: ElevatedButton(
                  //   child: Icon(Icons.payment),
                  //   onPressed: _pay,
                  // )
                  // child: Row(
                  //   children: [
                  //     ApplePayButton(
                  //       paymentConfigurationAsset: 'applePay.json',
                  //       paymentItems: _paymentItems,
                  //       width: 150,
                  //       style: ApplePayButtonStyle.black,
                  //       type: ApplePayButtonType.buy,
                  //       margin: const EdgeInsets.only(top: 15.0),
                  //       onPaymentResult: (data){
                  //         print(data);
                  //       },
                  //       loadingIndicator: const Center(
                  //         child: CircularProgressIndicator(),
                  //       ),
                  //     ),
                  //
                  //     GooglePayButton(
                  //       paymentConfigurationAsset: 'gpay.json',
                  //       paymentItems: _paymentItems,
                  //       width: 150,
                  //       style: GooglePayButtonStyle.black,
                  //       type: GooglePayButtonType.pay,
                  //       margin: const EdgeInsets.only(top: 15.0),
                  //       onPaymentResult: (data){
                  //         print(data);
                  //       },
                  //       loadingIndicator: const Center(
                  //         child: CircularProgressIndicator(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
