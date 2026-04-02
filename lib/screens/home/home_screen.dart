import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/home_provider.dart';
import 'widgets/product_card.dart';
import 'all_products_screen.dart';

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

              const SizedBox(height: 20),

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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(imageUrl, fit: BoxFit.cover),
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

              /// 🔥 CATEGORY HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    GestureDetector(
                      onTap: _showAllCategories,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7F5AF0).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.grid_view, size: 16, color: Color(0xFF7F5AF0)),
                            SizedBox(width: 5),
                            Text(
                              "All",
                              style: TextStyle(color: Color(0xFF7F5AF0)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// 🔥 CATEGORY GRID
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
              _sectionTitle(
                "Trending Products",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllProductsScreen(),
                    ),
                  );
                },
              ),

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
                            sellingPrice:
                            (product["sellingPrice"] ?? 0).toDouble(),
                            specialPrice:
                            (product["specialPrice"] ?? 0).toDouble(),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const SizedBox(),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// 🔥 NAVBAR
      bottomNavigationBar: SizedBox(
        height: 85,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            /// ✅ FIXED WIDTH CALCULATION (NO OVERFLOW)
            final itemWidth = (width - 10) / 5;

            final icons = [
              Icons.home,
              Icons.favorite_border,
              Icons.search,
              Icons.shopping_cart,
              Icons.person,
            ];

            /// ✅ CENTER POSITION (IMPORTANT)
            final centerX =
                currentIndex * itemWidth + itemWidth / 2 + 20;

            return Stack(
              alignment: Alignment.center,
              children: [

                /// 🔥 CURVED NAVBAR WITH WAVE
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                /// 🔥 ICONS ROW
                Positioned.fill(
                  child: Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => currentIndex = index),
                        child: SizedBox(
                          width: itemWidth,
                          child: Icon(
                            icons[index],
                            color: currentIndex == index
                                ? Colors.transparent
                                : Colors.white54,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                /// 🔥 FLOATING ACTIVE ICON
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: 20,
                  left: centerX - 40,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F5AF0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7F5AF0).withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Icon(
                      icons[currentIndex],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🔥 FULL DRAWER (FIXED)
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111111),
      child: Column(
        children: [

          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F5AF0), Color(0xFF5A3FD0)],
              ),
            ),
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

          _drawerItem(Icons.description, "Terms & Conditions", 5),
          _drawerItem(Icons.privacy_tip, "Privacy Policy", 6),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final isSelected = selectedDrawerIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF7F5AF0) : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF7F5AF0) : Colors.white,
        ),
      ),
      tileColor: isSelected
          ? const Color(0xFF7F5AF0).withOpacity(0.1)
          : Colors.transparent,
      onTap: () {
        setState(() => selectedDrawerIndex = index);
        Navigator.pop(context);
      },
    );
  }

  void _showAllCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 3,
          children: const [
            _CategoryItem(icon: Icons.phone_android, label: "Electronics"),
            _CategoryItem(icon: Icons.checkroom, label: "Fashion"),
            _CategoryItem(icon: Icons.chair, label: "Home"),
            _CategoryItem(icon: Icons.sports_esports, label: "Gaming"),
            _CategoryItem(icon: Icons.watch, label: "Watches"),
            _CategoryItem(icon: Icons.more, label: "More"),
          ],
        );
      },
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFF7F5AF0)
              : Colors.white54,
          size: isSelected ? 26 : 22,
        ),
      ),
    );
  }

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

          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F5AF0).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.grid_view,
                        size: 16, color: Color(0xFF7F5AF0)),
                    SizedBox(width: 5),
                    Text(
                      "All",
                      style: TextStyle(
                        color: Color(0xFF7F5AF0),
                        fontWeight: FontWeight.w500,
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

/// CATEGORY ITEM
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFF7F5AF0)),
          ),
        ),
        const SizedBox(height: 6),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
class NavBarPainter extends CustomPainter {
  final double centerX;

  NavBarPainter(this.centerX);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.fill;

    final path = Path();

    const double radius = 25;
    const double curveWidth = 40;   // 🔥 SMALL WIDTH (IMPORTANT)
    const double curveHeight = -30; // 🔥 LIGHT LIFT ONLY

    path.moveTo(0, radius);

    /// LEFT EDGE
    path.quadraticBezierTo(0, 0, radius, 0);

    /// STRAIGHT LINE BEFORE CURVE
    path.lineTo(centerX - curveWidth, 0);

    /// 🔥 SMALL LOCAL CURVE (ONLY ICON AREA)
    path.quadraticBezierTo(
      centerX,
      curveHeight,
      centerX + curveWidth,
      0,
    );

    /// STRAIGHT LINE AFTER CURVE
    path.lineTo(size.width - radius, 0);

    /// RIGHT EDGE
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      radius,
    );

    /// BOTTOM
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) {
    return oldDelegate.centerX != centerX;
  }
}