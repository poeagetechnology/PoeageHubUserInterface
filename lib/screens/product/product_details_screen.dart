import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    String image = "";
    if (product["images"] != null &&
        product["images"].isNotEmpty) {
      image = product["images"][0];
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(product["name"] ?? ""),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🖼 IMAGE
            if (image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(image),
              ),

            const SizedBox(height: 20),

            /// 🏷 NAME
            Text(
              product["name"] ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// 💰 PRICE
            Text(
              "₹${product["sellingPrice"] ?? 0}",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            /// 📄 DESCRIPTION
            Text(
              product["description"] ?? "No description",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}