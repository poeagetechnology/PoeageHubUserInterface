import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/home_provider.dart';
import 'widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  int currentIndex = 0;
  int selectedDrawerIndex = 0;

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    final productsAsync = ref.watch(trendingProductsProvider);
    final bannerAsync = ref.watch(bannerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      drawer: _buildDrawer(),

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

                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "PoeageHub",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: const [
                        Icon(Icons.notifications_none, color: Colors.white),
                        SizedBox(width: 15),
                        Icon(Icons.favorite_border, color: Colors.white),
                      ],
                    )
                  ],
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
                error: (e, _) => const SizedBox(),
              ),

              const SizedBox(height: 25),

              /// 🔥 CATEGORY TITLE
              _sectionTitle("Categories", onTap: () {}),

              const SizedBox(height: 15),

              /// 🔥 CATEGORY GRID FIXED (overflow fix)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 110,
                  child: GridView.count(
                    crossAxisCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: const [
                      _CategoryItem(icon: Icons.phone_android, label: "Electronics"),
                      _CategoryItem(icon: Icons.checkroom, label: "Fashion"),
                      _CategoryItem(icon: Icons.chair, label: "Home"),
                      _CategoryItem(icon: Icons.sports_esports, label: "Gaming"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 TRENDING TITLE
              _sectionTitle("Trending Products", onTap: () {}),

              const SizedBox(height: 15),

              SizedBox(
                height: 240,
                child: productsAsync.when(
                  data: (snapshot) {

                    final products = snapshot.docs;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: products.length,
                      itemBuilder: (context, index) {

                        final product = products[index].data();

                        String image = "";
                        if (product["images"] != null &&
                            product["images"].isNotEmpty) {
                          image = product["images"][0];
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: ProductCard(
                            name: product["name"] ?? "",
                            image: image,
                            sellingPrice: (product["sellingPrice"] ?? 0).toDouble(),
                            specialPrice: (product["specialPrice"] ?? 0).toDouble(),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const SizedBox(),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// 🔥 NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFF7F5AF0),
        unselectedItemColor: Colors.white54,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// 🔥 DRAWER
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111111),
      child: Column(
        children: [

          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF7F5AF0)),
            accountName: Text(user?.displayName ?? "User"),
            accountEmail: Text(user?.email ?? "No Email"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),

          _drawerItem(Icons.receipt_long, "Orders", 0),
          _drawerItem(Icons.favorite_border, "Wishlist", 1),
          _drawerItem(Icons.settings, "Settings", 2),
          _drawerItem(Icons.support_agent, "Help & Support", 3),
          _drawerItem(Icons.info_outline, "About", 4),

          const Spacer(),

          const Divider(color: Colors.white24),

          _drawerItem(Icons.description, "Terms", 4),
          _drawerItem(Icons.privacy_tip, "Privacy", 5),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final isSelected = selectedDrawerIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Color(0xFF7F5AF0) : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Color(0xFF7F5AF0) : Colors.white,
        ),
      ),
      onTap: () {
        setState(() => selectedDrawerIndex = index);
      },
    );
  }

  /// 🔥 SECTION TITLE WITH VIEW ALL
  Widget _sectionTitle(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: onTap,
            child: const Text(
              "View All",
              style: TextStyle(
                color: Color(0xFF7F5AF0),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// 🔥 CATEGORY ITEM
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Color(0xFF7F5AF0)),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}