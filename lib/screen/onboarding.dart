import 'package:fitness_proj/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_proj/model/onboarding_model.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Data for the three onboarding pages
  final List<OnboardPageModel> pages = [
    OnboardPageModel(
      title: "CHALLENGE YOUR LIMITS",
      description: "Access personalized training plans designed to push past plateaus and redefine your strength.",
      imagePath: "assets/images/boy_1.png", // Placeholder for a dynamic image
    ),
    OnboardPageModel(
      title: "TRACK YOUR PROGRESS",
      description: "Visualize your gains, log every workout, and celebrate every milestone on your fitness journey.",
      imagePath: "assets/images/boy_2.png",
    ),
    OnboardPageModel(
      title: "JOIN THE FEARLESS CLUB",
      description: "Connect with a community that motivates you, shares tips, and holds you accountable for success.",
      imagePath: "assets/images/boy_3.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  // Helper function to create the page indicator dots
  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? kAccentGold : kOffWhite,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == pages.length - 1;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Page View (Main Slides)
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                model: pages[index],
              );
            },
          ),

          // Bottom Controls Layer
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (index) => _buildPageIndicator(index)),
                  ),
                  const SizedBox(height: 15),

                  // Navigation Row (Skip/Next or Get Started)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SKIP Button
                      if (!isLastPage)
                        TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              pages.length - 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: kOffWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 60), // Space placeholder for alignment

                      // NEXT / GET STARTED Button
                        isLastPage
                            ? ElevatedButton(
                                onPressed: () {
                                  // TODO: Navigate to Home Screen
                                  print("Onboarding Finished!");
                                
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAccentGold,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    color: kNearBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : FloatingActionButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeIn,
                                  );
                                },
                                backgroundColor: kAccentGold,
                                shape: const CircleBorder(),
                                elevation: 4,
                                child: const Icon(Icons.arrow_forward_ios_rounded, color: kNearBlack, size: 24),
                              ),
                      ],
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