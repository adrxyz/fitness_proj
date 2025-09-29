import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Implement SingleTickerProviderStateMixin for the AnimationController
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  
  // Animation for the Icon (Dumbbell)
  late AnimationController _controller;
  late Animation<Offset> _iconSlideAnimation;
  
  // Animation for the Text (Tagline)
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  // NEW: Animation for the Loading Indicator
  late Animation<double> _loadingFadeAnimation;


  @override
  void initState() {
    super.initState();
    
    // Initialize the Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Total animation time
    );

    // 1. Icon Animation (Starts immediately)
    _iconSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // 2. Text Animation (Starts at 40% of the duration, 600ms)
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), 
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // 3. Loading Animation (Starts at 60% of the duration, 900ms)
    _loadingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );


    // Start the animations and the overall fade-in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
      _controller.forward();
    });

    // 4. Handle the navigation after the required delay
    _navigateToNextScreen(); 
  }
  
  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }


  void _navigateToNextScreen() async { 
    // Simulation of Initialization Delay (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Navigation is now fixed to always go to the onboarding screen.
    const String nextRoute = '/onboarding';

    if (mounted) {
      // Navigate and replace the splash screen in the navigation stack
      Navigator.of(context).pushReplacementNamed(nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // NEW: Dark Red/Maroon gradient theme
          gradient: LinearGradient(
            colors: [kPrimaryMaroon, Color(0xFF5B0217)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // AnimatedOpacity still controls the initial full screen fade-in
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 1000), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Animated Icon (Slide Transition)
                SlideTransition(
                  position: _iconSlideAnimation,
                  child: const Icon(
                    Icons.fitness_center_rounded, 
                    size: 80,
                    // NEW: Gold/Yellow color
                    color: kAccentGold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 2. Animated Text (Slide and Fade Transition)
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: SlideTransition(
                    position: _textSlideAnimation,
                    child: const Text(
                      'Your Fitness, Your Way',
                      style: TextStyle(
                        // NEW: Off-White for contrast
                        color: kOffWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                
                // 3. Animated Loading Indicator (Fades in smoothly)
                FadeTransition(
                  opacity: _loadingFadeAnimation,
                  child: const CircularProgressIndicator(
                    // NEW: Gold/Yellow color
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentGold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}