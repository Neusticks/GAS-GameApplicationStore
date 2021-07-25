import 'Base.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String PRODUCT_QUANTITY_KEY = "product_quantity";
  static const String REVIEW_ID_KEY = "review_id";

  String productUid;
  String orderDate;
  int productQuantity;
  String reviewID;

  OrderedProduct(
      String id, {
        this.productUid,
        this.orderDate,
        this.productQuantity,
        this.reviewID
      }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      productQuantity: map[PRODUCT_QUANTITY_KEY],
      reviewID: map[REVIEW_ID_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      PRODUCT_QUANTITY_KEY : productQuantity,
      REVIEW_ID_KEY : reviewID,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (productQuantity != null) map[PRODUCT_QUANTITY_KEY] = productQuantity;
    if (reviewID != null) map[REVIEW_ID_KEY] = reviewID;
    return map;
  }
}
