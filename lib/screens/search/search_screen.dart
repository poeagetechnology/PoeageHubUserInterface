import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  File? selectedImage;

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

  ///  PICK IMAGE
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });


    }
  }

  void showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Camera",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text("Gallery",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
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

            ///  SEARCH BAR
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
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// CAMERA BUTTON
                  IconButton(
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.white70),
                    onPressed: showImagePickerSheet,
                  ),

                  if (searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),

            ///  SELECTED IMAGE PREVIEW
            if (selectedImage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            /// HISTORY
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: clearHistory,
                      child: const Text("Clear",
                          style: TextStyle(color: Colors.red)),
                    )
                  ],
                ),
              ),

            if (query.isEmpty)
              Wrap(
                spacing: 8,
                children: searchHistory.map((item) {
                  return ActionChip(
                    label: Text(item),
                    backgroundColor: const Color(0xFF1C1C1E),
                    labelStyle: const TextStyle(color: Colors.white),
                    onPressed: () {
                      searchController.text = item;
                      setState(() {});
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 10),

            /// PRODUCTS
            Expanded(
              child: productsAsync.when(
                data: (snapshot) {
                  final products =
                  snapshot.docs.map((e) => e.data()).toList();

                  final filtered = products.where((product) {
                    final name =
                    (product["name"] ?? "").toString().toLowerCase();
                    return name.contains(query);
                  }).toList();

                  if (query.isEmpty && selectedImage == null) {
                    return _emptyUI();
                  }

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("No products found 😔",
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];

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
                                child: Image.network(
                                  image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product["name"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(
                  child: Text("Error loading products",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///  EMPTY UI
  Widget _emptyUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.white24),
          SizedBox(height: 10),
          Text(
            "Search or use image to find products",
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}