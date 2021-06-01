import 'package:flutter/material.dart';

import 'Product.dart';
import 'Base.dart';

class Cart extends Model {
  static const String PRODUCT_ID_KEY = "productId";
  static const String ITEM_QTY_KEY = "itemQty";

  int itemQty;
  Cart({
    String id,
    this.itemQty = 0,
  }) : super(id);

  factory Cart.fromMap(Map<String, dynamic> map, {String id}) {
    return Cart(
      id: id,
      itemQty: map[ITEM_QTY_KEY],
    );
  }
   @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      ITEM_QTY_KEY: itemQty,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (itemQty != null) map[ITEM_QTY_KEY] = itemQty;
    return map;
  }
}

// class Cart {
//   final Product product;
//   final int numOfItem;

//   Cart({@required this.product, @required this.numOfItem});
// }

// // Demo data for our cart

// List<Cart> demoCarts = [
//   Cart(product: demoProducts[0], numOfItem: 2),
//   Cart(product: demoProducts[1], numOfItem: 1),
//   Cart(product: demoProducts[3], numOfItem: 1),
// ];
