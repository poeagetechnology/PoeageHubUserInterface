import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final double sellingPrice;
  final double specialPrice;

  const ProductCard({
    super.key,
    required this.name,
    required this.image,
    required this.sellingPrice,
    required this.specialPrice,
  });

  @override
  Widget build(BuildContext context) {

    final double finalPrice =
    (specialPrice > 0) ? specialPrice : sellingPrice;

    final int discount =
    (sellingPrice > 0 && finalPrice < sellingPrice)
        ? ((sellingPrice - finalPrice) / sellingPrice * 100).round()
        : 0;

    return Container(
      width: 165,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // 🔥 DARK GLASS
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 IMAGE SECTION
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: image.isNotEmpty
                    ? Image.network(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image, color: Colors.white54),
                  ),
                )
                    : Container(
                  height: 140,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.image, color: Colors.white54),
                ),
              ),

              /// ❤️ WISHLIST ICON
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              /// 🔥 DISCOUNT BADGE
              if (discount > 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD80A28), // 🔥 BRAND COLOR
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$discount% OFF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          /// 🔽 PRODUCT INFO
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 📝 NAME
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                /// 💰 PRICE
                Row(
                  children: [

                    Text(
                      "₹${finalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Color(0xFF7F5AF0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(width: 6),

                    if (discount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          "₹${sellingPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 5, // 🔥 IMPORTANT
                            color: Colors.white70,  // 🔥 MORE VISIBLE
                            fontSize: 13,           // 🔥 SLIGHTLY BIGGER
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}