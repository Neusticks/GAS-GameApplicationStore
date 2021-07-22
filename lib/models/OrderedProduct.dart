import 'package:flutter/material.dart';

import 'Base.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String BUYER_ID_KEY = "buyerId";
  static const String SELLER_ID_KEY = "sellerId";

  String productUid;
  String sellerId;
  String orderDate;
  String buyerId;
  OrderedProduct(
      String id, {
        this.productUid,
        this.orderDate,
        this.buyerId,
        this.sellerId,
      }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      buyerId: map[BUYER_ID_KEY],
      sellerId: map[SELLER_ID_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      BUYER_ID_KEY: buyerId,
      SELLER_ID_KEY: sellerId,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (buyerId != null) map[BUYER_ID_KEY] = buyerId;
    if (sellerId != null) map[SELLER_ID_KEY] = sellerId;
    return map;
  }
}
