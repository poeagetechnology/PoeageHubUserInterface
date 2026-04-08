import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/home_provider.dart';
import 'widgets/product_card.dart';

class AllProductsScreen extends ConsumerWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productsAsync = ref.watch(trendingProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E6E6),
        title: const Text("All Products"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: productsAsync.when(
          data: (snapshot) {
            final products = snapshot.docs;

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {

                final product = products[index].data();

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
            );
          },
          loading: () =>
          const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(child: Text("Error")),
        ),
      ),
    );
  }
}