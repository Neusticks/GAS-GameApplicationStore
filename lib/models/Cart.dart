import 'Base.dart';

class Cart extends Model {
  static const String PRODUCT_ID_KEY = "productId";
  static const String ITEM_QTY_KEY = "itemQty";
  static const String ITEM_CART_CHECKED = "itemChecked";
  static const String SELLER_ID_KEY = "sellerId";

  bool itemChecked;
  String sellerId;
  int itemQty;
  Cart({
    String id,
    this.itemQty = 1,
    this.sellerId,
    this.itemChecked = true,
  }) : super(id);

  factory Cart.fromMap(Map<String, dynamic> map, {String id}) {
    return Cart(
      id: id,
      itemQty: map[ITEM_QTY_KEY],
      itemChecked: map[ITEM_CART_CHECKED],
      sellerId: map[SELLER_ID_KEY],
    );
  }
  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      ITEM_QTY_KEY: itemQty,
      ITEM_CART_CHECKED: itemChecked,
      SELLER_ID_KEY: sellerId,
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
