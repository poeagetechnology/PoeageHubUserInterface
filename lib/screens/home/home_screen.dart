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
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello 👋",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Welcome to PoeageHub",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Row(
                      children: [
                        Icon(Icons.notifications_none, size: 28),
                        SizedBox(width: 15),
                        Icon(Icons.shopping_cart_outlined, size: 28),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Search products...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Icon(Icons.mic),
                      SizedBox(width: 10),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              bannerAsync.when(
                data: (snapshot) {
                  final banners = snapshot.docs;

                  if (banners.isEmpty) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: banners.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {

                        final banner = banners[index].data();
                        final imageUrl = banner["imageUrl"] ?? "";

                        return Container(
                          width: MediaQuery.of(context).size.width - 40,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image),
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
                  child: Center(child: Text("Banner Error")),
                ),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.75,
                  children: const [
                    _CategoryItem(icon: Icons.phone_android, label: "Electronics"),
                    _CategoryItem(icon: Icons.checkroom, label: "Fashion"),
                    _CategoryItem(icon: Icons.chair, label: "Home"),
                    _CategoryItem(icon: Icons.sports_esports, label: "Gaming"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 230,
                child: productsAsync.when(

                  data: (snapshot) {

                    final products = snapshot.docs;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("No products available"),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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

                        final double finalPrice =
                        (specialPrice > 0) ? specialPrice : sellingPrice;

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
                    child: Text("Error: $e"),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// 🔹 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
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
}

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
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF)),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}