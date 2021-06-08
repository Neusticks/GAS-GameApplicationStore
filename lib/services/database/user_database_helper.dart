import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/models/Address.dart';
import 'package:gas_gameappstore/models/Cart.dart';
import 'package:gas_gameappstore/models/OrderedProduct.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";
  static const String USER_EMAIL_KEY = "userEmail";
  static const String USER_NAME_KEY = "userName";
  static const String USER_PASSWORD_KEY = "userPassword";
  static const String USER_DATE_OF_BIRTH_KEY = "userDOB";
  static const String USER_GENDER_KEY = "userGender";
  static const String USER_PHONE_NUMBER_KEY = "userPhoneNumber";
  static const String USER_ADDRESS_KEY = "userAddress";
  static const String USER_TRANSACTION_PIN_KEY = "userTransactionPIN";
  static const String USER_ROLE_KEY = "userRole";
  static const String USER_PROFILE_PICTURE_KEY = "userProfilePicture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
  UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewUser(String uid, String email, String password, String gender, String dob) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
     USER_EMAIL_KEY: email,
     USER_NAME_KEY : null,
     USER_PASSWORD_KEY: password,
     USER_DATE_OF_BIRTH_KEY : dob,
     USER_GENDER_KEY : gender,
     USER_PHONE_NUMBER_KEY: null,
     USER_ADDRESS_KEY: null,
     USER_TRANSACTION_PIN_KEY: null,
     USER_ROLE_KEY : 'Customer',
     USER_PROFILE_PICTURE_KEY: null,
    });
  }

  // Future<void> deleteCurrentUserData() async {
  //   final uid = AuthentificationService().currentUser.uid;
  //   final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
  //   final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
  //   final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
  //   final ordersCollectionRef =
  //   docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

  //   final cartDocs = await cartCollectionRef.get();
  //   for (final cartDoc in cartDocs.docs) {
  //     await cartCollectionRef.doc(cartDoc.id).delete();
  //   }
  //   final addressesDocs = await addressCollectionRef.get();
  //   for (final addressDoc in addressesDocs.docs) {
  //     await addressCollectionRef.doc(addressDoc.id).delete();
  //   }
  //   final ordersDoc = await ordersCollectionRef.get();
  //   for (final orderDoc in ordersDoc.docs) {
  //     await ordersCollectionRef.doc(orderDoc.id).delete();
  //   }

  //   await docRef.delete();
  // }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
    if (favList.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY];
    return favList;
  }

  Future<bool> switchProductFavouriteStatus(
      String productId, bool newState) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<List<String>> get addressesList async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    // ignore: deprecated_member_use
    final addresses = List<String>();
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });

    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id)
        .get();
    final address = Address.fromMap(doc.data(), id: doc.id);
    return address;
  }

  Future<bool> addAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressesCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<Cart> getCartItemFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final cartItem = Cart.fromMap(docSnapshot.data(), id: docSnapshot.id);
    return cartItem;
  }

  Future<bool> addProductToCart(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(productId);
    final docSnapshot = await docRef.get();
    bool alreadyPresent = docSnapshot.exists;
    if (alreadyPresent == false) {
      docRef.set(Cart(itemQty: 1).toMap());
    } else {
      docRef.update({Cart.ITEM_QTY_KEY: FieldValue.increment(1)});
    }
    return true;
  }

  Future<List<String>> emptyCart() async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    // ignore: deprecated_member_use
    List orderedProductsUid = List<String>();
    for (final doc in cartItems.docs) {
      orderedProductsUid.add(doc.id);
      await doc.reference.delete();
    }
    return orderedProductsUid;
  }

  Future<num> get cartTotal async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount = doc.data()[Cart.ITEM_QTY_KEY];
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      total += (itemsCount * product.productDiscountPrice);
    }
    return total;
  }

  Future<bool> removeProductFromCart(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
    return true;
  }

  Future<bool> increaseCartItemCount(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({Cart.ITEM_QTY_KEY: FieldValue.increment(1)});
    return true;
  }

  Future<bool> decreaseCartItemCount(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();
    int currentCount = docSnapshot.data()[Cart.ITEM_QTY_KEY];
    if (currentCount <= 1) {
      return removeProductFromCart(cartItemID);
    } else {
      docRef.update({Cart.ITEM_QTY_KEY: FieldValue.increment(-1)});
    }
    return true;
  }

  Future<List<String>> get allCartItemsList async {
    String uid = AuthentificationService().currentUser.uid;
    final querySnapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    // ignore: deprecated_member_use
    List itemsId = List<String>();
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
    }
    return itemsId;
  }

  // Future<List<String>> get orderedProductsList async {
  //   String uid = AuthentificationService().currentUser.uid;
  //   final orderedProductsSnapshot = await firestore
  //       .collection(USERS_COLLECTION_NAME)
  //       .doc(uid)
  //       .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
  //       .get();
  //   List orderedProductsId = List<String>();
  //   for (final doc in orderedProductsSnapshot.docs) {
  //     orderedProductsId.add(doc.id);
  //   }
  //   return orderedProductsId;
  // }

  Future<bool> addToMyOrders(List<OrderedProduct> orders) async {
    String uid = AuthentificationService().currentUser.uid;
    final orderedProductsCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add(order.toMap());
    }
    return true;
  }

  // Future<OrderedProduct> getOrderedProductFromId(String id) async {
  //   String uid = AuthentificationService().currentUser.uid;
  //   final doc = await firestore
  //       .collection(USERS_COLLECTION_NAME)
  //       .doc(uid)
  //       .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
  //       .doc(id)
  //       .get();
  //   final orderedProduct = OrderedProduct.fromMap(doc.data(), id: doc.id);
  //   return orderedProduct;
  // }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String userId = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(userId)
        .get()
        .asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({USER_PHONE_NUMBER_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/userProfilePicture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {USER_PROFILE_PICTURE_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        USER_PROFILE_PICTURE_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[USER_PROFILE_PICTURE_KEY];
  }
}
