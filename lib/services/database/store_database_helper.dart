import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/models/Address.dart';
import 'package:gas_gameappstore/models/Cart.dart';
import 'package:gas_gameappstore/models/Store.dart';
import 'package:gas_gameappstore/models/OrderedProduct.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';

class StoreDatabaseHelper {
  static const String STORE_COLLECTION_NAME = "stores";
  static const String USERS_COLLECTION_NAME = "users";
  static const String USER_STORE_ID_KEY = "userStoreId";
  static const String STORE_NAME_KEY = "storeName";
  static const String STORE_SELLER_NAME_KEY = "storeSellerName";
  static const String STORE_OWNER_ID_KEY = "storeOwnerID";
  static const String STORE_ADDRESS_KEY = "storeAddress";
  static const String STORE_DESCRIPTION_KEY = "storeDescription";
  static const String STORE_RATING_KEY = "storeRating";
  static const String STORE_PICTURE_KEY = "storePicture";

  StoreDatabaseHelper._privateConstructor();
  static StoreDatabaseHelper _instance =
      StoreDatabaseHelper._privateConstructor();
  factory StoreDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> createUserStore(
      String storeId,
      String storeName,
      String storeSellerName,
      String storeAddress,
      String storeDescription) async {
    String uid = AuthentificationService().currentUser.uid;
    await firestore.collection(STORE_COLLECTION_NAME).doc(storeId).set({
      STORE_NAME_KEY: storeName,
      STORE_SELLER_NAME_KEY: storeSellerName,
      STORE_ADDRESS_KEY: storeAddress,
      STORE_OWNER_ID_KEY: uid,
      STORE_DESCRIPTION_KEY: storeDescription,
      STORE_RATING_KEY: 0.0,
      STORE_PICTURE_KEY: null,
    });
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).update({
      USER_STORE_ID_KEY: storeId,
    });
    return storeId;
  }

  Future<List<String>> get userStoreWithId async {
    String uid = AuthentificationService().currentUser.uid;
    final storeCollectionRef = firestore.collection(STORE_COLLECTION_NAME);
    final querySnapshot = await storeCollectionRef
        .where(Store.USER_STORE_OWNER_ID_KEY, isEqualTo: uid)
        .get();

    List userStore = List<String>();
    querySnapshot.docs.forEach((doc) {
      userStore.add(doc.id);
    });
    return userStore;
  }

  String getPathForCurrentUserStoreDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "store/storeDisplayPicture/$currentUserUid";
  }

  Future<bool> uploadStoreDisplayPicture(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final storeDocSnapshot =
        firestore.collection(STORE_COLLECTION_NAME).doc(uid);
    await storeDocSnapshot.update(
      {STORE_PICTURE_KEY: url},
    );
    return true;
  }

  Future<bool> removeStoreDisplayPicture() async {
    String uid = AuthentificationService().currentUser.uid;
    final storeDocSnapshot =
        firestore.collection(STORE_COLLECTION_NAME).doc(uid);
    await storeDocSnapshot.update(
      {
        STORE_PICTURE_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get storeDisplayPicture async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        await firestore.collection(STORE_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[STORE_PICTURE_KEY];
  }
}
