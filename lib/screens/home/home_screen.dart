import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/home_provider.dart';
import 'widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productsAsync = ref.watch(trendingProductsProvider);
    final bannerAsync = ref.watch(bannerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello 👋",
                          style: TextStyle(fontSize: 14, color: Colors.white54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "PoeageHub",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                        const SizedBox(width: 15),
                        const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                      ],
                    )
                  ],
                ),
              ),

              /// 🔍 SEARCH BAR (GLASS STYLE)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white54),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Search products...",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                      Icon(Icons.mic, color: Colors.white54),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 BANNER
              bannerAsync.when(
                data: (snapshot) {

                  final banners = snapshot.docs;
                  if (banners.isEmpty) return const SizedBox();

                  return SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: banners.length,
                      itemBuilder: (context, index) {

                        final banner = banners[index].data();
                        final imageUrl = banner["imageUrl"] ?? "";

                        return Container(
                          width: MediaQuery.of(context).size.width - 60,
                          margin: const EdgeInsets.only(right: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade800,
                                child: const Icon(Icons.image, color: Colors.white54),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => const SizedBox(
                  height: 160,
                  child: Center(child: Text("Banner Error", style: TextStyle(color: Colors.white))),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 SECTION TITLE
              _sectionTitle("Categories"),

              const SizedBox(height: 15),

              /// 🔥 CATEGORIES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8,
                  children: const [
                    _CategoryItem(icon: Icons.phone_android, label: "Electronics"),
                    _CategoryItem(icon: Icons.checkroom, label: "Fashion"),
                    _CategoryItem(icon: Icons.chair, label: "Home"),
                    _CategoryItem(icon: Icons.sports_esports, label: "Gaming"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _sectionTitle("Trending Products"),

              const SizedBox(height: 15),

              /// 🔥 PRODUCTS
              SizedBox(
                height: 240,
                child: productsAsync.when(

                  data: (snapshot) {

                    final products = snapshot.docs;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("No products", style: TextStyle(color: Colors.white)),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: products.length,
                      itemBuilder: (context, index) {

                        final product = products[index].data();

                        String image = "";
                        if (product["images"] != null &&
                            product["images"] is List &&
                            product["images"].isNotEmpty) {
                          image = product["images"][0];
                        }

                        final double sellingPrice =
                        (product["sellingPrice"] ?? 0).toDouble();

                        final double specialPrice =
                        (product["specialPrice"] ?? 0).toDouble();

                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: ProductCard(
                            name: product["name"] ?? "",
                            image: image,
                            sellingPrice: sellingPrice,
                            specialPrice: specialPrice,
                          ),
                        );
                      },
                    );
                  },

                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),

                  error: (e, _) => Center(
                    child: Text("Error: $e", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// 🔥 DARK BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFF7F5AF0),
        unselectedItemColor: Colors.white54,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// 🔥 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 🔥 CATEGORY ITEM (DARK STYLE)
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Color(0xFF7F5AF0)),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}