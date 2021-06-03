import 'package:enum_to_string/enum_to_string.dart';

import 'Base.dart';

// class Product {
//   final int id;
//   final String title, description;
//   final List<String> images;
//   final List<Color> colors;
//   final double rating, price;
//   final bool isFavourite, isPopular;

//   Product({
//     @required this.id,
//     @required this.images,
//     @required this.colors,
//     this.rating = 0.0,
//     this.isFavourite = false,
//     this.isPopular = false,
//     @required this.title,
//     @required this.price,
//     @required this.description,
//   });
// }

// // Our demo Products

// List<Product> demoProducts = [
//   Product(
//     id: 1,
//     images: [
//       "assets/images/ps4_console_white_1.png",
//       "assets/images/ps4_console_white_2.png",
//       "assets/images/ps4_console_white_3.png",
//       "assets/images/ps4_console_white_4.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Wireless Controller for PS4™",
//     price: 64.99,
//     description: description,
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Product(
//     id: 2,
//     images: [
//       "assets/images/Image Popular Product 2.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Nike Sport White - Man Pant",
//     price: 50.5,
//     description: description,
//     rating: 4.1,
//     isPopular: true,
//   ),
//   Product(
//     id: 3,
//     images: [
//       "assets/images/glap.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Gloves XC Omega - Polygon",
//     price: 36.55,
//     description: description,
//     rating: 4.1,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Product(
//     id: 4,
//     images: [
//       "assets/images/wireless headset.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     title: "Logitech Head",
//     price: 20.20,
//     description: description,
//     rating: 4.1,
//     isFavourite: true,
//   ),
// ];

// const String description =
//     "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

enum ProductType {
  InGameCurrency,
  Services,
}

class Product extends Model {
  static const String PRODUCT_IMAGES_KEY = "productImages";
  static const String PRODUCT_Name_KEY = "productName";
  static const String PRODUCT_VARIANT_KEY = "productVariant";
  static const String PRODUCT_DISCOUNT_PRICE_KEY = "productDiscountPrice";
  static const String PRODUCT_ORIGINAL_PRICE_KEY = "productOriginalPrice";
  static const String PRODUCT_RATING_KEY = "productRating";
  static const String PRODUCT_HIGHLIGHTS_KEY = "productHighlights";
  static const String PRODUCT_DESCRIPTION_KEY = "productDescription";
  static const String SELLER_KEY = "sellerId";
  static const String OWNER_KEY = "ownerId";
  static const String PRODUCT_TYPE_KEY = "productType";
  static const String PRODUCT_SEARCH_TAGS_KEY = "productSearchTags";

  List<String> productImages;
  String productName;
  String productVariant;
  num productDiscountPrice;
  num productOriginalPrice;
  String productRating;
  String productHighlights;
  String productDescription;
  String sellerId;
  bool isFavourite;
  bool isPopular;
  String ownerId;
  ProductType productType;
  List<String> productSearchTags;

  Product(
    String id, {
    this.productImages,
    this.productName,
    this.productVariant,
    this.productType,
    this.productDiscountPrice,
    this.productOriginalPrice,
    this.productRating,
    this.productHighlights,
    this.productDescription,
    this.sellerId,
    this.ownerId,
    this.productSearchTags,
  }) : super(id);

  int calculatePercentageDiscount() {
    int discount = (((productOriginalPrice - productDiscountPrice) * 100) /
            productOriginalPrice)
        .round();
    return discount;
  }

  factory Product.fromMap(Map<String, dynamic> map, {String id}) {
    if (map[PRODUCT_SEARCH_TAGS_KEY] == null) {
      map[PRODUCT_SEARCH_TAGS_KEY] = List<String>();
    }
    return Product(
      id,
      productImages: map[PRODUCT_IMAGES_KEY].cast<String>(),
      productName: map[PRODUCT_Name_KEY],
      productVariant: map[PRODUCT_VARIANT_KEY],
      productType:
          EnumToString.fromString(ProductType.values, map[PRODUCT_TYPE_KEY]),
      productDiscountPrice: map[PRODUCT_DISCOUNT_PRICE_KEY],
      productOriginalPrice: map[PRODUCT_ORIGINAL_PRICE_KEY],
      productRating: map[PRODUCT_RATING_KEY],
      productHighlights: map[PRODUCT_HIGHLIGHTS_KEY],
      productDescription: map[PRODUCT_DESCRIPTION_KEY],
      sellerId: map[SELLER_KEY],
      ownerId: map[OWNER_KEY],
      productSearchTags: map[PRODUCT_SEARCH_TAGS_KEY].cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_IMAGES_KEY: productImages,
      PRODUCT_Name_KEY: productName,
      PRODUCT_VARIANT_KEY: productVariant,
      PRODUCT_TYPE_KEY: EnumToString.convertToString(productType),
      PRODUCT_DISCOUNT_PRICE_KEY: productDiscountPrice,
      PRODUCT_ORIGINAL_PRICE_KEY: productOriginalPrice,
      PRODUCT_RATING_KEY: productRating,
      PRODUCT_HIGHLIGHTS_KEY: productHighlights,
      PRODUCT_DESCRIPTION_KEY: productDescription,
      SELLER_KEY: sellerId,
      OWNER_KEY: ownerId,
      PRODUCT_SEARCH_TAGS_KEY: productSearchTags,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productImages != null) map[PRODUCT_IMAGES_KEY] = productImages;
    if (productName != null) map[PRODUCT_Name_KEY] = productName;
    if (productVariant != null) map[PRODUCT_VARIANT_KEY] = PRODUCT_VARIANT_KEY;
    if (productDiscountPrice != null) map[PRODUCT_DISCOUNT_PRICE_KEY] = productDiscountPrice;
    if (productOriginalPrice != null) map[PRODUCT_ORIGINAL_PRICE_KEY] = productOriginalPrice;
    if (productRating != null) map[PRODUCT_RATING_KEY] = PRODUCT_RATING_KEY;
    if (productHighlights != null) map[PRODUCT_HIGHLIGHTS_KEY] = productHighlights;
    if (productDescription != null) map[PRODUCT_DESCRIPTION_KEY] = productDescription;
    if (sellerId != null) map[SELLER_KEY] = sellerId;
    if (productType != null)
      map[PRODUCT_TYPE_KEY] = EnumToString.convertToString(productType);
    if (ownerId != null) map[OWNER_KEY] = ownerId;
    if (productSearchTags != null) map[PRODUCT_SEARCH_TAGS_KEY] = productSearchTags;

    return map;
  }
}
