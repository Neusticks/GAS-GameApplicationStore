import 'package:flutter/material.dart';

import 'Base.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String PRODUCT_QUANTITY_KEY = "product_quantity";
  static const String REVIEW_ID_KEY = "review_id";
  static const String TRANSACTION_COMPLETED_KEY = "transaction_completed";
  static const String USER_ID_KEY = "user_id";
  static const String STORE_ID_KEY = "store_id";

  String userID;
  String storeID;
  String productUid;
  String orderDate;
  int productQuantity;
  bool reviewID;
  bool transactionCompleted;

  OrderedProduct(
      String id, {
        this.userID,
        this.storeID,
        this.productUid,
        this.orderDate,
        this.productQuantity,
        this.reviewID = false,
        this.transactionCompleted = false,
      }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      userID: map[USER_ID_KEY],
      storeID: map[STORE_ID_KEY],
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      productQuantity: map[PRODUCT_QUANTITY_KEY],
      reviewID: map[REVIEW_ID_KEY],
      transactionCompleted: map[TRANSACTION_COMPLETED_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      USER_ID_KEY : userID,
      STORE_ID_KEY : storeID,
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      PRODUCT_QUANTITY_KEY : productQuantity,
      REVIEW_ID_KEY : reviewID,
      TRANSACTION_COMPLETED_KEY : transactionCompleted,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (userID != null) map[USER_ID_KEY] = userID;
    if (storeID != null) map[STORE_ID_KEY] = storeID;
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (productQuantity != null) map[PRODUCT_QUANTITY_KEY] = productQuantity;
    return map;
  }
}
