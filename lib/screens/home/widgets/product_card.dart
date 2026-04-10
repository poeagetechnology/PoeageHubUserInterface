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
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE SECTION
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: image.isNotEmpty
                    ? Image.network(
                  image,
                  height: 130, // 🔽 slightly reduced
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image, color: Colors.white54),
                  ),
                )
                    : Container(
                  height: 130,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.image, color: Colors.white54),
                ),
              ),

              ///  WISHLIST
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

              ///  DISCOUNT
              if (discount > 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD80A28),
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


          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🏷 NAME
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// PRICE
                  Row(
                    children: [
                      Text(
                        "₹${finalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Color(0xFF7F5AF0),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),

                      if (discount > 0)
                        Text(
                          "₹${sellingPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 3,
                            decorationColor:Colors.red,
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),


                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to cart "),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F5AF0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}