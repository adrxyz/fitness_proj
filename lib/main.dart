import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
import 'screen/onboarding.dart';
import 'package:fitness_proj/widgets/color_constant.dart';
import 'package:fitness_proj/screen/user_profile_screen.dart';

// The main entry point for the Flutter application.
void main() {
  runApp(const MyApp());
}

// ------------------------------------
// 0. MAIN APPLICATION WIDGET (Sets up the routes)
// ------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the primary color for consistent theming
        primaryColor: kAccentGold,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(kAccentGold.value, const <int, Color>{
            50: Color(0xFFFFFBEB),
            100: Color(0xFFFFF3C4),
            200: Color(0xFFFEE699),
            300: Color(0xFFFDD46F),
            400: Color(0xFFFBC052),
            500: kAccentGold, // EDB518
            600: Color(0xFFD4A316),
            700: Color(0xFFBB8F13),
            800: Color(0xFFA27C11),
            900: Color(0xFF89690E),
          }),
          backgroundColor: kOffWhite,
        ).copyWith(secondary: kPrimaryMaroon),
        
        // Define a modern text theme
        fontFamily: 'Inter',
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: kAccentGold, // Default button background
            foregroundColor: kNearBlack, // Default button text color
          ),
        ),
      ),
      // --- ROUTE DEFINITIONS ---
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        // Navigate to the Onboarding Flow after the splash screen
        '/onboarding': (context) => OnboardingScreen(),
        '/user-profile-setup': (context) => const UserProfileSetupScreen(),
      },
    );
  }
}
