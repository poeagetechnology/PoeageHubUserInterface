import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  TRENDING PRODUCTS
  Stream<QuerySnapshot<Map<String, dynamic>>> getTrendingProducts() {
    return _firestore
        .collectionGroup('items')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  /// PRODUCTS BY CATEGORY
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsByCategory(String category) {
    return _firestore
        .collectionGroup('items')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  ///  PRODUCTS BY SUBCATEGORY
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsBySubCategory(String subCategory) {
    return _firestore
        .collectionGroup('items')
        .where('subCategory', isEqualTo: subCategory)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  ///  BANNERS
  Stream<QuerySnapshot<Map<String, dynamic>>> getBanners() {
    return _firestore
        .collection("offer_banners")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  ///  DYNAMIC CATEGORIES FROM PRODUCTS
  Stream<List<String>> getDynamicCategories() {
    return _firestore
        .collectionGroup('items')
        .snapshots()
        .map((snapshot) {

      final categoriesSet = <String>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data.containsKey('category') &&
            data['category'] != null &&
            data['category'].toString().isNotEmpty) {

          categoriesSet.add(data['category']);
        }
      }

      return categoriesSet.toList();
    });
  }
}