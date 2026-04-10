import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),

    /// TEMP (we upgrade later)
    const Center(child: Text("Wishlist")),
    const Center(child: Text("Search")),
    const Center(child: Text("Cart")),
    const Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],
      backgroundColor: Colors.black87,


      bottomNavigationBar: SizedBox(
        height: 85,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = (width - 10) / 5;

            final icons = [
              Icons.home,
              Icons.favorite_border,
              Icons.search,
              Icons.shopping_cart,
              Icons.person,
            ];

            final centerX =
                currentIndex * itemWidth + itemWidth / 2 + 20;

            return Stack(
              alignment: Alignment.center,
              children: [

                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                Positioned.fill(
                  child: Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
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

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: 20,
                  left: centerX - 40,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F5AF0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icons[currentIndex],
                      color: Colors.white,
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
}