import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        ///  FULL SCREEN IMAGE
        Positioned.fill(
          child: Image.asset(
            data.image,
            fit: BoxFit.cover, // VERY IMPORTANT
          ),
        ),

        ///  GRADIENT OVERLAY (SMOOTH MERGE)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 150,
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
    );
  }
}