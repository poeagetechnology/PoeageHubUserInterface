import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    /// IMAGE LOGIC
    String image = "";
    if (product["images"] != null &&
        product["images"].isNotEmpty) {
      image = product["images"][0];
    }

    /// PRICE LOGIC
    final double sellingPrice =
    (product["sellingPrice"] ?? 0).toDouble();

    final double specialPrice =
    (product["specialPrice"] ?? 0).toDouble();

    final double finalPrice =
    (specialPrice > 0) ? specialPrice : sellingPrice;

    final int discount =
    (sellingPrice > 0 && finalPrice < sellingPrice)
        ? ((sellingPrice - finalPrice) / sellingPrice * 100).round()
        : 0;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(product["name"] ?? ""),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// IMAGE + DISCOUNT BADGE
              Stack(
                children: [
                  if (image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(image),
                    ),

                  if (discount > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD80A28),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$discount% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              /// NAME
              Text(
                product["name"] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// PRICE SECTION
              Row(
                children: [

                  /// FINAL PRICE
                  Text(
                    "₹${finalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Color(0xFF7F5AF0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ORIGINAL PRICE
                  if (discount > 0)
                    Text(
                      "₹${sellingPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 3,
                        decorationColor:Colors.red

                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              /// DESCRIPTION
              Text(
                product["description"] ?? "No description",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              /// ADD TO CART BUTTON
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Added to cart 🛒"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F5AF0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}