import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/widgets/product_card.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String category;
  final List<Map<String, dynamic>> allProducts;

  const CategoryProductsScreen({
    super.key,
    required this.category,
    required this.allProducts,
  });

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {

  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filterProducts();
  }

  void filterProducts() {
    List<Map<String, dynamic>> temp = [];

    for (var product in widget.allProducts) {
      
      print(" PRODUCT: $product");

      final category = product["category"] ??
          product["mainCategory"] ??
          product["type"] ??
          "";

      print("Product Category: $category");
      print("Selected Category: ${widget.category}");

      if (category.toString().toLowerCase().trim() ==
          widget.category.toLowerCase().trim()) {
        temp.add(product);
      }
    }

    print("FILTERED COUNT: ${temp.length}");

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
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          widget.category,
          style: const TextStyle(color: Colors.white),
        ),
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

          final product = filteredProducts[index];

          String image = "";
          if (product["images"] != null &&
              product["images"].isNotEmpty) {
            image = product["images"][0];
          }

          double sellingPrice =
          (product["sellingPrice"] ?? 0).toDouble();

          double specialPrice =
          (product["specialPrice"] ?? 0).toDouble();

          return ProductCard(
            name: product["name"] ?? "No Name",
            image: image,
            sellingPrice: sellingPrice,
            specialPrice: specialPrice,
          );
        },
      ),
    );
  }
}