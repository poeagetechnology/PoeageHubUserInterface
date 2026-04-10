import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/providers/home_provider.dart';
import '../../screens/product/product_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList("search_history") ?? [];
    });
  }

  Future<void> saveSearch(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      searchHistory.remove(query);
      searchHistory.insert(0, query);

      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
    });

    await prefs.setStringList("search_history", searchHistory);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("search_history");

    setState(() => searchHistory.clear());
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(trendingProductsProvider);
    final query = searchController.text.toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Column(
          children: [


            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (value) => saveSearch(value),
                      decoration: const InputDecoration(
                        hintText: "Search products, brands...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (searchController.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    )
                ],
              ),
            ),

            /// RECENT SEARCHES
            if (query.isEmpty && searchHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Searches",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: clearHistory,
                      child: const Text(
                        "Clear",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
              ),

            if (query.isEmpty && searchHistory.isNotEmpty)
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: searchHistory.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          searchController.text = item;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 10),


            Expanded(
              child: productsAsync.when(
                data: (snapshot) {
                  final products =
                  snapshot.docs.map((doc) => doc.data()).toList();

                  final filteredProducts = products.where((product) {
                    final name =
                    (product["name"] ?? "").toString().toLowerCase();
                    return name.contains(query);
                  }).toList();

                  /// EMPTY SEARCH
                  if (query.isEmpty) {
                    return _emptySearchUI();
                  }

                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No products found 😔",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      String image = "";
                      if (product["images"] != null &&
                          product["images"].isNotEmpty) {
                        image = product["images"][0];
                      }

                      return GestureDetector(
                        onTap: () {
                          saveSearch(product["name"] ?? "");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: image.isNotEmpty
                                    ? Image.network(
                                  image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey,
                                  child: const Icon(Icons.image),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product["name"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹${product["sellingPrice"] ?? 0}",
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => const Center(
                  child: Text(
                    "Error loading products",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _emptySearchUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search, size: 80, color: Colors.white24),
        SizedBox(height: 10),
        Text(
          "Search for products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Find your favorite items instantly",
          style: TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}