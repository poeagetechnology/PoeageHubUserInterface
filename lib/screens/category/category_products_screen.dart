import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/widgets/product_card.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {

  List<QueryDocumentSnapshot> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final productsSnapshot =
    await FirebaseFirestore.instance.collection('products').get();

    List<QueryDocumentSnapshot> temp = [];

    for (var doc in productsSnapshot.docs) {
      final categorySnapshot = await doc.reference
          .collection('categories')
          .get();

      for (var cat in categorySnapshot.docs) {
        if (cat.id.toLowerCase() == widget.category.toLowerCase()) {
          temp.add(doc);
          break;
        }
      }
    }

    setState(() {
      filteredProducts = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: Text(widget.category),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredProducts.isEmpty
          ? const Center(
        child: Text(
          "No products found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: filteredProducts.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final product =
          filteredProducts[index].data() as Map<String, dynamic>;

          String image = "";
          if (product["images"] != null &&
              product["images"].isNotEmpty) {
            image = product["images"][0];
          }

          return ProductCard(
            name: product["name"] ?? "",
            image: image,
            sellingPrice:
            (product["sellingPrice"] ?? 0).toDouble(),
            specialPrice:
            (product["specialPrice"] ?? 0).toDouble(),
          );
        },
      ),
    );
  }
}