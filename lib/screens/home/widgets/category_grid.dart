import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {

  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {

    final categories = [
      {"icon": Icons.phone_android, "label": "Electronics"},
      {"icon": Icons.checkroom, "label": "Fashion"},
      {"icon": Icons.chair, "label": "Home"},
      {"icon": Icons.sports_esports, "label": "Gaming"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {

          final category = categories[index];

          return Column(
            children: [

              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  category["icon"] as IconData,
                  color: const Color(0xFF6C63FF),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                category["label"].toString(),
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),

            ],
          );
        },
      ),
    );
  }
}