import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/home_service.dart';

/// HomeService Provider
final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService();
});

/// Trending Products Provider (Home Screen)
final trendingProductsProvider =
StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {

  final homeService = ref.watch(homeServiceProvider);

  return homeService.getTrendingProducts();
});

/// Products by Category Provider (Future Category Screen)
final productsByCategoryProvider =
StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>((ref, category) {

  final homeService = ref.watch(homeServiceProvider);

  return homeService.getProductsByCategory(category);
});

/// Products by SubCategory Provider (Future Subcategory Screen)
final productsBySubCategoryProvider =
StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>((ref, subCategory) {

  final homeService = ref.watch(homeServiceProvider);

  return homeService.getProductsBySubCategory(subCategory);
});

final bannerProvider =
StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {

  final homeService = ref.watch(homeServiceProvider);

  return homeService.getBanners();
});