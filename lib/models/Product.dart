import 'package:enum_to_string/enum_to_string.dart';

import 'Base.dart';

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
  num productRating;
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
    this.productRating = 0.0,
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
    if (productVariant != null) map[PRODUCT_VARIANT_KEY] = productVariant;
    if (productDiscountPrice != null) map[PRODUCT_DISCOUNT_PRICE_KEY] = productDiscountPrice;
    if (productOriginalPrice != null) map[PRODUCT_ORIGINAL_PRICE_KEY] = productOriginalPrice;
    if (productRating != null) map[PRODUCT_RATING_KEY] = productRating;
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
