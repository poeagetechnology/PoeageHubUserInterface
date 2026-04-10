import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/providers/home_provider.dart';
import '../../screens/product/product_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(trendingProductsProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search products...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),

      body: productsAsync.when(
        data: (snapshot) {

          final products = snapshot.docs.map((doc) => doc.data()).toList();

          final query = searchController.text.toLowerCase();

          final filteredProducts = products.where((product) {
            final name = (product["name"] ?? "").toString().toLowerCase();
            return name.contains(query);
          }).toList();

          if (query.isEmpty) {
            return const Center(
              child: Text(
                "Start searching...",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text(
                "No products found 😔",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {

              final product = filteredProducts[index];

              String image = "";
              if (product["images"] != null &&
                  product["images"].isNotEmpty) {
                image = product["images"][0];
              }

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },

                leading: image.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image, color: Colors.white),

                title: Text(
                  product["name"] ?? "",
                  style: const TextStyle(color: Colors.white),
                ),

                subtitle: Text(
                  "₹${product["sellingPrice"] ?? 0}",
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => const Center(
          child: Text(
            "Error loading products",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}