
import 'package:gas_gameappstore/models/Product.dart';
import 'package:gas_gameappstore/models/Review.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";
  static const String REVIEWS_COLLECTION_NAME = "reviews";

  ProductDatabaseHelper._privateConstructor();
  static ProductDatabaseHelper _instance =
  ProductDatabaseHelper._privateConstructor();
  factory ProductDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<List<String>> searchInProducts(String query,
      {ProductType productType}) async {
    Query queryRef;
    if (productType == null) {
      queryRef = firestore.collection(PRODUCTS_COLLECTION_NAME);
    } else {
      final productTypeStr = EnumToString.convertToString(productType);
      print(productTypeStr);
      queryRef = firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .where(Product.PRODUCT_TYPE_KEY, isEqualTo: productTypeStr);
    }

    Set productsId = Set<String>();
    final querySearchInTags = await queryRef
        .where(Product.PRODUCT_SEARCH_TAGS_KEY, arrayContains: query)
        .get();
    for (final doc in querySearchInTags.docs) {
      productsId.add(doc.id);
    }
    final queryRefDocs = await queryRef.get();
    for (final doc in queryRefDocs.docs) {
      final product = Product.fromMap(doc.data(), id: doc.id);
      if (product.productName.toString().toLowerCase().contains(query) ||
          product.productDescription.toString().toLowerCase().contains(query) ||
          product.productHighlights.toString().toLowerCase().contains(query) ||
          product.productVariant.toString().toLowerCase().contains(query) ||
          product.sellerId.toString().toLowerCase().contains(query)) {
        productsId.add(product.id);
      }
    }
    return productsId.toList();
  }

  Future<bool> addProductReview(String productId, Review review) async {
    final reviewsCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDoc = reviewsCollectionRef.doc(review.id);
    if ((await reviewDoc.get()).exists == false) {
      reviewDoc.set(review.toMap());
      return await addUsersRatingForProduct(
        productId,
        review.rating,
      );
    } else {
      int oldRating = 0;
      oldRating = (await reviewDoc.get()).data()[Product.PRODUCT_RATING_KEY];
      reviewDoc.update(review.toUpdateMap());
      return await addUsersRatingForProduct(productId, review.rating,
          oldRating: oldRating);
    }
  }

  Future<bool> addUsersRatingForProduct(String productId, int rating,
      {int oldRating}) async {
    final productDocRef =
    firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    final ratingsCount =
        (await productDocRef.collection(REVIEWS_COLLECTION_NAME).get())
            .docs
            .length;
    final productDoc = await productDocRef.get();
    final prevRating = productDoc.data()[Review.RATING_KEY];
    double newRating = 0;
    print(ratingsCount);
    if (oldRating == null) {
      newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
    } else {
      newRating =
          (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
    }
    final newRatingRounded = double.parse(newRating.toStringAsFixed(1));
    await productDocRef.update({Product.PRODUCT_RATING_KEY: newRatingRounded});
    return true;
  }

  Future<Review> getProductReviewWithID(
      String productId, String reviewId) async {
    final reviewsCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDoc = await reviewsCollectionRef.doc(reviewId).get();
    if (reviewDoc.exists) {
      return Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
    }
    return null;
  }

  Stream<List<Review>> getAllReviewsStreamForProductId(
      String productId) async* {
    final reviewsQuerySnapshot = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME)
        .get()
        .asStream();
    await for (final querySnapshot in reviewsQuerySnapshot) {
      List<Review> reviews = List<Review>();
      for (final reviewDoc in querySnapshot.docs) {
        Review review = Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
        reviews.add(review);
      }
      yield reviews;
    }
  }

  Future<Product> getProductWithID(String productId) async {
    final docSnapshot = await firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .get();

    if (docSnapshot.exists) {
      return Product.fromMap(docSnapshot.data(), id: docSnapshot.id);
    }
    return null;
  }

  Future<String> addUsersProduct(Product product) async {
    String uid = AuthentificationService().currentUser.uid;
    final productMap = product.toMap();
    product.ownerId = uid;
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(product.toMap());
    await docRef.update({
      Product.PRODUCT_SEARCH_TAGS_KEY: FieldValue.arrayUnion(
          [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
    });
    return docRef.id;
  }

  Future<bool> deleteUserProduct(String productId) async {
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
    return true;
  }

  Future<String> updateUsersProduct(Product product) async {
    final productMap = product.toUpdateMap();
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = productsCollectionReference.doc(product.id);
    await docRef.update(productMap);
    if (product.productType != null) {
      await docRef.update({
        Product.PRODUCT_SEARCH_TAGS_KEY: FieldValue.arrayUnion(
            [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
      });
    }
    return docRef.id;
  }

  Future<List<String>> getCategoryProductsList(ProductType productType) async {
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final queryResult = await productsCollectionReference
        .where(Product.PRODUCT_TYPE_KEY,
        isEqualTo: EnumToString.convertToString(productType))
        .get();
    List productsId = List<String>();
    for (final product in queryResult.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }

  Future<List<String>> get usersProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference
        .where(Product.OWNER_KEY, isEqualTo: uid)
        .get();
    List usersProducts = List<String>();
    querySnapshot.docs.forEach((doc) {
      usersProducts.add(doc.id);
    });
    return usersProducts;
  }

  Future<List<String>> get allProductsList async {
    final products = await firestore.collection(PRODUCTS_COLLECTION_NAME).get();
    List productsId = List<String>();
    for (final product in products.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }

  Future<bool> updateProductsImages(
      String productId, List<String> imgUrl) async {
    final Product updateProduct = Product(null, productImages: imgUrl);
    final docRef =
    firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
    return true;
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}
