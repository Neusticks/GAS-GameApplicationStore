import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/components/product_short_detail_card.dart';
import 'package:gas_gameappstore/models/Cart.dart';
import 'package:gas_gameappstore/models/OrderedProduct.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/screens/ProductDetails/product_details_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/data_streams/cart_stream.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'dart:math';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../utils.dart';
import 'check_out_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CartStream cartStream = CartStream();
  PersistentBottomSheetController bottomSheetController;
  List<bool> checked = [true];
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    cartStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    cartStream.dispose();
  }

  Future<void> refreshPage() {
    cartStream.reload();
    return Future<void>.value();
  }

  String getRandomString(int length){
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var random = Random.secure();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));
  }

  Future<void> onCardEntryComplete() async{
    //Success, clear cart
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Success!'),
        content: const Text('Your order has been paid!'),
        actions: <Widget>[
          TextButton(
            onPressed: () async{
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    final uid = AuthentificationService().currentUser.uid;
    final cartItems = await FirebaseFirestore.instance.collection("users").doc(uid).collection("cart").get();
    final orderFuture = UserDatabaseHelper().emptyCart();
    orderFuture.then((orderedProductsUid) async {
      if (orderedProductsUid != null) {
        print(orderedProductsUid);
        final dateTime = DateTime.now();
        final formatedDateTime =
            "${dateTime.day}-${dateTime.month}-${dateTime.year}";
        List<OrderedProduct> orderedProductsCombined = [];
        for(int i = 0; i < orderedProductsUid.length; i++){
          int itemQty = cartItems.docs.elementAt(i).data()["itemQty"];
          final productRef = await FirebaseFirestore.instance.collection("products").doc(cartItems.docs.elementAt(i).id).get();
          final storeRef = await FirebaseFirestore.instance.collection("stores").where("storeOwnerID", isEqualTo: productRef.data()["ownerId"]).get();
          final storeRefSnapshot = storeRef.docs.single;
          List<OrderedProduct> orderedProducts = orderedProductsUid.map((e) => OrderedProduct(null, userID: uid, storeID: storeRefSnapshot.id, productUid: e, orderDate: formatedDateTime, productQuantity: itemQty)).toList();
          orderedProductsCombined.add(orderedProducts.elementAt(i));
        }
        bool addedProductsToMyProducts = false;
        String snackbarMessage;
        try {
          addedProductsToMyProducts =
          await UserDatabaseHelper().addToMyOrders(orderedProductsCombined);
          if (addedProductsToMyProducts) {
            snackbarMessage = "Products ordered Successfully";
          } else {
            throw "Could not order products due to unknown issue";
          }
        } on FirebaseException catch (e) {
          Logger().e(e.toString());
          snackbarMessage = e.toString();
        } catch (e) {
          Logger().e(e.toString());
          snackbarMessage = e.toString();
        } finally {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarMessage ?? "Something went wrong"),
            ),
          );
        }
      } else {
        throw "Something went wrong while clearing cart";
      }
      await showDialog(
        context: context,
        builder: (context) {
          return FutureProgressDialog(
            orderFuture,
            message: Text("Placing the Order"),
          );
        },
      );
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          orderFuture,
          message: Text("Placing the Order"),
        );
      },
    );
    await refreshPage();
  }

  Future<bool> onCardNonceRequestSuccess(CardDetails result) async{
    print(result.nonce);
    //chargeCard(result);

    InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
    return true;
  }

  Future<bool> onCardEntryCancel() async{
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Cancelled'),
        content: const Text('Input card credential has been cancelled!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return false;
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
                    "Your Cart",
                    style: headingStyle,
                  ),
                  Text(
                    "Swipe RIGHT to Delete",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: getProportionScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: Center(
                      child: buildCartItemsList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> itemsCartId = snapshot.data;

          if (itemsCartId.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          return Column(
            children: [
              DefaultButton(
                text: "Proceed to Payment",
                press: () {
                  bottomSheetController = Scaffold.of(context).showBottomSheet(
                    (context) {
                      return CheckoutCard(
                        onCheckoutPressed: checkoutButtonCallback,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: getProportionScreenHeight(15)),
              DefaultButton(
                text: "Empty Cart",
                press: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Empty Cart'),
                        content: const Text('Are you sure you want to empty cart?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async{
                              await UserDatabaseHelper().emptyCart();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Cart has been emptied!"),
                                ),
                              );
                              Navigator.pop(context, 'Yes');
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                              onPressed: () async{
                                Navigator.pop(context, 'No');
                              },
                              child: const Text('No'),
                          ),
                        ],
                      )
                  );
                  await refreshPage();
                }
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: itemsCartId.length,
                  itemBuilder: (context, index) {
                    if (index >= itemsCartId.length) {
                      return SizedBox(height: getProportionScreenHeight(80));
                    }
                    return buildCartItemDismissible(
                        context, itemsCartId[index], index);
                  },
                ),
              ),
            ],
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

  Widget buildCartItemDismissible(
      BuildContext context, String cartItemId, int index) {
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildCartItem(cartItemId, index),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            if (direction == DismissDirection.startToEnd) {
              bool result = false;
              String snackbarMessage;
              try {
                result = await UserDatabaseHelper()
                    .removeProductFromCart(cartItemId);
                if (result == true) {
                  snackbarMessage = "Product removed from cart successfully";
                  await refreshPage();
                } else {
                  throw "Couldn't remove product from cart due to unknown reason";
                }
              } on FirebaseException catch (e) {
                Logger().w("Firebase Exception: $e");
                snackbarMessage = "Something went wrong";
              } catch (e) {
                Logger().w("Unknown Exception: $e");
                snackbarMessage = "Something went wrong";
              } finally {
                Logger().i(snackbarMessage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snackbarMessage),
                  ),
                );
              }

              return result;
            }
          }
        }
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(cartItemId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: kTextColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_up,
                            color: kTextColor,
                          ),
                          onTap: () async {
                            await arrowUpCallback(cartItemId);
                          },
                        ),
                        SizedBox(height: 8),
                        FutureBuilder<Cart>(
                          future: UserDatabaseHelper()
                              .getCartItemFromId(cartItemId),
                          builder: (context, snapshot) {
                            int itemCount = 0;
                            if (snapshot.hasData) {
                              final cartItem = snapshot.data;
                              itemCount = cartItem.itemQty;
                            } else if (snapshot.hasError) {
                              final error = snapshot.error.toString();
                              Logger().e(error);
                            }
                            return Text(
                              "$itemCount",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: kTextColor,
                          ),
                          onTap: () async {
                            await arrowDownCallback(cartItemId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> checkoutButtonCallback() async {
    shutBottomSheet();

    await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-_F5YicVyQRFBdw0P2orLKA');
    await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: onCardNonceRequestSuccess, onCardEntryCancel: onCardEntryCancel);
  }

  void shutBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController.close();
    }
  }

  Future<void> arrowUpCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().increaseCartItemCount(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }

  Future<void> arrowDownCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().decreaseCartItemCount(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }

  // getTotalAmount() {
  //   var count = 0;
  //   for (int i = 0; i < checked.length; i++) {
  //     if (checked[i]) {
  //       count = count + 1;
  //     }
  //     if (i == checked.length - 1) {
  //       setState(() {
  //         totalAmount = 248 * count;
  //       });
  //     }
  //   }
  // }
}
