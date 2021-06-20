import 'Base.dart';

class Store extends Model {
  static const String USER_STORE_NAME_KEY = "userStoreName";
  static const String USER_STORE_OWNER_ID_KEY = "userStoreOwnerId";
  static const String USER_STORE_SELLER_NAME_KEY = "userStoreSellerName";
  static const String USER_STORE_ADDRESS_KEY = "userStoreAddress";
  static const String USER_STORE_PICTURE_KEY = "userStorePicture";
  static const String USER_STORE_DESCRIPTION_KEY = "userStoreDescription";
  static const String USER_STORE_RATING_KEY = "userStoreRating";
  static const String PRODUCT_ID_KEY = "productId";

  String storeId;
  String storeName;
  String storeOwnerId;
  String storeSellerName;
  String storeAddress;
  String storePicture;
  String storeDescription;
  num storeRating;

  Store(
    String id, {
    this.storeName,
    this.storeOwnerId,
    this.storeSellerName,
    this.storeAddress,
    this.storeDescription,
    this.storePicture,
    this.storeRating = 0.0,
  }) : super(id);

  factory Store.fromMap(Map<String, dynamic> map, {String id}) {
    return Store(
      id,
      storeName: map[USER_STORE_NAME_KEY],
      storeOwnerId: map[USER_STORE_OWNER_ID_KEY],
      storeSellerName: map[USER_STORE_SELLER_NAME_KEY],
      storeAddress: map[USER_STORE_ADDRESS_KEY],
      storeDescription: map[USER_STORE_DESCRIPTION_KEY],
      storePicture: map[USER_STORE_PICTURE_KEY].cast<String>(),
      storeRating: map[USER_STORE_RATING_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      USER_STORE_NAME_KEY: storeName,
      USER_STORE_OWNER_ID_KEY: storeOwnerId,
      USER_STORE_SELLER_NAME_KEY: storeSellerName,
      USER_STORE_ADDRESS_KEY: storeAddress,
      USER_STORE_DESCRIPTION_KEY: storeDescription,
      USER_STORE_PICTURE_KEY: storePicture,
      USER_STORE_RATING_KEY: storeRating,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (storeName != null) map[USER_STORE_NAME_KEY] = storeName;
    if (storeOwnerId != null) map[USER_STORE_OWNER_ID_KEY] = storeOwnerId;
    if (storeSellerName != null) map[USER_STORE_SELLER_NAME_KEY] = storeSellerName;
    if (storeAddress != null) map[USER_STORE_ADDRESS_KEY] = storeAddress;
    if (storeDescription != null)
      map[USER_STORE_DESCRIPTION_KEY] = storeDescription;
    if (storeRating != null) map[USER_STORE_RATING_KEY] = storeRating;
    if (storePicture != null) map[USER_STORE_PICTURE_KEY] = storePicture;

    return map;
  }
}
