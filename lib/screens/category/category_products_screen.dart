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

  /// 🔥 FILTER VARIABLES
  String selectedSort = "none";
  double minPrice = 0;
  double maxPrice = 100000;

  @override
  void initState() {
    super.initState();
    filterProducts();
  }

  void filterProducts() {
    List<Map<String, dynamic>> temp = [];

    for (var product in widget.allProducts) {

      final category = product["category"] ??
          product["mainCategory"] ??
          product["type"] ??
          "";

      double price = (product["sellingPrice"] ?? 0).toDouble();

      if (category.toString().toLowerCase().trim() ==
          widget.category.toLowerCase().trim()) {

        /// 🔥 PRICE FILTER
        if (price >= minPrice && price <= maxPrice) {
          temp.add(product);
        }
      }
    }

    /// 🔥 SORTING
    if (selectedSort == "low_to_high") {
      temp.sort((a, b) =>
          (a["sellingPrice"] ?? 0)
              .compareTo(b["sellingPrice"] ?? 0));
    } else if (selectedSort == "high_to_low") {
      temp.sort((a, b) =>
          (b["sellingPrice"] ?? 0)
              .compareTo(a["sellingPrice"] ?? 0));
    }

    setState(() {
      filteredProducts = temp;
      isLoading = false;
    });
  }

  /// 🔥 FILTER BOTTOM SHEET
  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Filters",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔽 SORT DROPDOWN
                  DropdownButton<String>(
                    dropdownColor: Colors.black,
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: "none",
                        child: Text("No Sorting",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: "low_to_high",
                        child: Text("Price: Low to High",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: "high_to_low",
                        child: Text("Price: High to Low",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        selectedSort = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 💰 PRICE RANGE
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 100000,
                    divisions: 20,
                    labels: RangeLabels(
                      minPrice.toInt().toString(),
                      maxPrice.toInt().toString(),
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      filterProducts(); // 🔥 APPLY
                    },
                    child: const Text("Apply Filters"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      /// 🔥 UPGRADED APPBAR
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: showFilterBottomSheet,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : filteredProducts.isEmpty

      /// 🔥 BEAUTIFUL EMPTY UI
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off,
                size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "No Products Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try different filters or category",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )

      /// 🔥 PRODUCTS GRID
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