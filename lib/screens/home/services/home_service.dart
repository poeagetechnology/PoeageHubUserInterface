import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getTrendingProducts() {
    return _firestore
        .collectionGroup('items')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsByCategory(String category) {
    return _firestore
        .collectionGroup('items')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsBySubCategory(String subCategory) {
    return _firestore
        .collectionGroup('items')
        .where('subCategory', isEqualTo: subCategory)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBanners() {
    return _firestore
        .collection("offer_banners")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }
}