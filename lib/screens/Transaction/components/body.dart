import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/models/OrderedProduct.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/models/Review.dart';
import 'package:gas_gameappstore/screens/ProductDetails/product_details_screen.dart';
import 'package:gas_gameappstore/screens/Transaction/components/product_review_dialog.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/data_streams/ordered_products_stream.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'TransactionShortDetailCard.dart';

// class Body extends StatefulWidget{
//   @override
//   _BodyState createState() => _BodyState();
// }
//
// class _BodyState extends State<Body>{
//   final OrderedProductsStream orderedProductsStream = OrderedProductsStream();
//   List<bool> checked = [true];
//
//   @override
//   void initState(){
//     super.initState();
//     orderedProductsStream.init();
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//     orderedProductsStream.dispose();
//   }
//
//   Future<void> refreshPage(){
//     orderedProductsStream.reload();
//     return Future<void>.value();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: RefreshIndicator(
//         onRefresh: refreshPage,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: getProportionScreenWidth(screenPadding)),
//             child: SizedBox(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   SizedBox(height: getProportionScreenHeight(10)),
//                   Text(
//                     "Your Transaction",
//                     style: headingStyle,
//                   ),
//                   SizedBox(height: getProportionScreenHeight(20)),
//                   SizedBox(
//                     height: SizeConfig.screenHeight * 0.75,
//                     child: Center(
//                       child: buildFavoriteProductItemsList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildFavoriteProductItemsList(){
//     return StreamBuilder<List<String>>(
//       stream: orderedProductsStream.stream,
//       builder: (context, snapshot){
//         if(snapshot.hasData){
//           List<String> transactionProduct = snapshot.data;
//
//           if (transactionProduct.length == 0) {
//             return Center(
//               child: NothingToShowContainer(
//                 iconPath: "assets/icons/empty_cart.svg",
//                 secondaryMessage: "You have no transaction or ordered products!",
//               ),
//             );
//           }
//
//           return Column(
//             children: [
//               SizedBox(height: getProportionScreenHeight(20)),
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   physics: BouncingScrollPhysics(),
//                   itemCount: transactionProduct.length,
//                   itemBuilder: (context, index) {
//                     if (index >= transactionProduct.length) {
//                       return SizedBox(height: getProportionScreenHeight(80));
//                     }
//                     return buildFavoriteProductItemDismissible(
//                         context, transactionProduct[index], index);
//                   },
//                 ),
//               ),
//             ],
//           );
//         }else if(snapshot.connectionState == ConnectionState.waiting){
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }else if(snapshot.hasError){
//           final error = snapshot.error;
//           Logger().w(error.toString());
//         }
//         return Center(
//           child: NothingToShowContainer(
//             iconPath: "assets/icons/network_error.svg",
//             primaryMessage: "Something went wrong",
//             secondaryMessage: "Unable to connect to Database",
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildFavoriteProductItemDismissible(BuildContext context, String transactionProductId, int index){
//     return Dismissible(
//       key: Key(transactionProductId),
//       direction: DismissDirection.startToEnd,
//       dismissThresholds: {
//         DismissDirection.startToEnd: 0.65,
//       },
//       background: buildDismissibleBackground(),
//       child: buildFavoriteProductItem(transactionProductId, index),
//       onDismissed: (direction) {},
//     );
//   }
//
//   Widget buildDismissibleBackground() {
//     return Container(
//       padding: EdgeInsets.only(left: 20),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.delete,
//             color: Colors.white,
//           ),
//           SizedBox(width: 4),
//           Text(
//             "Delete",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildFavoriteProductItem(String transactionProductId, int index){
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: 4,
//         top: 4,
//         right: 4,
//       ),
//       margin: EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         border: Border.all(color: kTextColor.withOpacity(0.85)),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: FutureBuilder<Product>(
//         future: ProductDatabaseHelper().getProductWithID(transactionProductId),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             Product product = snapshot.data;
//             return Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(
//                   flex: 8,
//                   child: TransactionShortDetailCard(
//                     productId: product.id,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetailsScreen(
//                             productId: product.id,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//               ],
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             final error = snapshot.error;
//             Logger().w(error.toString());
//             return Center(
//               child: Text(
//                 error.toString(),
//               ),
//             );
//           } else {
//             return Center(
//               child: Icon(
//                 Icons.error,
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final OrderedProductsStream orderedProductsStream = OrderedProductsStream();

  @override
  void initState() {
    super.initState();
    orderedProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionScreenHeight(10)),
                  Text(
                    "Your Orders",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: buildOrderedProductsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<String>>(
      stream: orderedProductsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data;
          if (orderedProductsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper()
                    .getOrderedProductFromId(orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    return buildOrderedProductItem(orderedProduct);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    final error = snapshot.error.toString();
                    Logger().e(error);
                  }
                  return Icon(
                    Icons.error,
                    size: 60,
                    color: kTextColor,
                  );
                },
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildOrderedProductItem(OrderedProduct orderedProduct) {
    return FutureBuilder<Product>(
      future:
      ProductDatabaseHelper().getProductWithID(orderedProduct.productUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.12),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Ordered on:  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: orderedProduct.orderDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  child: TransactionShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      ).then((_) async {
                        await refreshPage();
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      String currentUserUid =
                          AuthentificationService().currentUser.uid;
                      Review prevReview;
                      try {
                        prevReview = await ProductDatabaseHelper()
                            .getProductReviewWithID(product.id, currentUserUid);
                      } on FirebaseException catch (e) {
                        Logger().w("Firebase Exception: $e");
                      } catch (e) {
                        Logger().w("Unknown Exception: $e");
                      } finally {
                        if (prevReview == null) {
                          prevReview = Review(
                            currentUserUid,
                            reviewerUid: currentUserUid,
                          );
                        }
                      }

                      final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return ProductReviewDialog(
                            review: prevReview,
                          );
                        },
                      );
                      if (result is Review) {
                        bool reviewAdded = false;
                        String snackbarMessage;
                        try {
                          reviewAdded = await ProductDatabaseHelper()
                              .addProductReview(product.id, result);
                          if (reviewAdded == true) {
                            snackbarMessage =
                            "Product review added successfully";
                          } else {
                            throw "Coulnd't add product review due to unknown reason";
                          }
                        } on FirebaseException catch (e) {
                          Logger().w("Firebase Exception: $e");
                          snackbarMessage = e.toString();
                        } catch (e) {
                          Logger().w("Unknown Exception: $e");
                          snackbarMessage = e.toString();
                        } finally {
                          Logger().i(snackbarMessage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackbarMessage),
                            ),
                          );
                        }
                      }
                      await refreshPage();
                    },
                    child: Text(
                      "Give Product Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          Logger().e(error);
        }
        return Icon(
          Icons.error,
          size: 60,
          color: kTextColor,
        );
      },
    );
  }
}