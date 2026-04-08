import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      title: "Discover Curated Style",
      subtitle:
      "Step into a world of thoughtfully curated collections — from fashion to technology and everyday essentials.Designed to match your taste, your needs, and your lifestyle.\n\nShopping isn’t just easier here… it feels personal.",
      image: "assets/onboard/onboard1.jpeg",
    ),
    OnboardingModel(
      title: "Effortless Shopping",
      subtitle:
      "Experience a seamless journey from browsing to checkout with an interface crafted for simplicity and speed.\n\nFind what you love, compare with ease, and shop confidently — all in just a few taps.\n\nEverything you need, exactly when you need it.",
      image: "assets/onboard/onboard2.jpeg",
    ),
    OnboardingModel(
      title: "Fast & Secure Delivery",
      subtitle:
      "Your orders are handled with care and delivered with precision.\n\nEnjoy real-time tracking, secure transactions, and dependable delivery right to your doorstep.\n\nBecause you deserve a shopping experience you can trust.",
      image: "assets/onboard/onboard3.jpeg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          final data = onboardingData[index];

          return Column(
            children: [

              /// 🔥 TOP IMAGE
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        data.image,
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// 🔻 Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔘 DOTS
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => dot(index == currentIndex),
                  ),
                ),
              ),

              /// 🔽 TEXT + BUTTON
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [

                      /// TITLE
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// SUBTITLE (IMPROVED SPACING)
                      Text(
                        data.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      /// 🔥 GRADIENT BUTTON
                      InkWell(
                        onTap: () async {
                          if (currentIndex ==
                              onboardingData.length - 1) {
                            final prefs =
                            await SharedPreferences.getInstance();
                            await prefs.setBool('seenOnboarding', true);

                            Navigator.pushReplacementNamed(
                                context, '/login');
                          } else {
                            _controller.nextPage(
                              duration:
                              const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF693D9F),
                                Color(0xFFAF84EF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              currentIndex ==
                                  onboardingData.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔘 DOT
  Widget dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: active ? 20 : 8,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}