import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

class OnboardPageModel {
  final String title;
  final String description;
  final String imagePath;

  OnboardPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// Widget for a single onboarding page slide
class OnboardingPage extends StatelessWidget {
  final OnboardPageModel model;

  const OnboardingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // kNearBlack RGB: (0, 4, 7)
    // kPrimaryMaroon RGB: (121, 3, 29)

    return Container(
      color: kNearBlack, // Ensure background is near-black
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image (Local Asset)
          Image.asset(
            model.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback Widget if the asset file is not found (due to missing pubspec entry, etc.)
              return Container(
                color: kPrimaryMaroon, // Use the primary color as a bold fallback
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    color: kAccentGold,
                    size: 80,
                  ),
                ),
              );
            },
            // ALPHA CHANNEL REPLACEMENT: kNearBlack.withOpacity(0.15) -> Color.fromARGB(38, 0, 4, 7)
            color: Color.fromARGB(38, 0, 4, 7), 
            colorBlendMode: BlendMode.darken,
          ),

          // 2. Gradient Overlay (Maroon/Black fade up from bottom)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // ALPHA CHANNEL REPLACEMENT: kNearBlack.withOpacity(0.0) -> Color.fromARGB(0, 0, 4, 7)
                  Color.fromARGB(0, 0, 4, 7), // Top: transparent
                  
                  // ALPHA CHANNEL REPLACEMENT: kPrimaryMaroon.withOpacity(0.25) -> Color.fromARGB(64, 121, 3, 29)
                  Color.fromARGB(64, 121, 3, 29), // Middle: Maroon fade
                  
                  // ALPHA CHANNEL REPLACEMENT: kNearBlack.withOpacity(0.85) -> Color.fromARGB(217, 0, 4, 7)
                  Color.fromARGB(217, 0, 4, 7), // Bottom: Near Black
                ],
                stops: const [0.5, 0.75, 1.0],
              ),
            ),
          ),

          // 3. Text Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 120.0), // Above controls
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    model.title,
                    style: TextStyle(
                      color: kAccentGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: [
                        BoxShadow(
                          // kNearBlack.withOpacity(0.5) is still used here for the shadow,
                          // as it is a standard practice and not part of the primary opacity
                          // replacement request for the page background effects.
                          color: Color.fromARGB(127, 0, 4, 7), 
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    model.description,
                    style: TextStyle(
                      color: kOffWhite,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
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
