import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';
import 'package:fitness_proj/sign_in/sign_in.dart';
import 'package:fitness_proj/login/login.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // True for Login, False for Signup
  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  // Helper function for custom-styled Text Fields
  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: isPassword,
      style: const TextStyle(color: kOffWhite),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: kAccentGold),
        filled: true,
        fillColor: kDarkGrey,
        labelStyle: TextStyle(color: kAccentGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentGold, width: 2),
        ),
      ),
    );
  }

  // Helper function for Social Media Buttons
  Widget _buildSocialButton(BuildContext context, String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing in with $label...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kNearBlack,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 5,
            )
          ]
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. SET BACKGROUND TO MAROON
      backgroundColor: kPrimaryMaroon,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App Logo/Title
              Icon(Icons.directions_run_rounded, size: 80, color: kAccentGold),
              const SizedBox(height: 8),
              Text(
                _isLogin ? 'WELCOME BACK' : 'JOIN THE GYM',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  // 2. SET TEXT COLOR TO YELLOW (kAccentGold)
                  color: kAccentGold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),

              // Animated Switcher between Login and Sign Up Cards
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLogin
                    ? LoginView(
                        key: const ValueKey('login'),
                        toggleAuthMode: _toggleAuthMode,
                        buildTextField: _buildTextField,
                        buildSocialButton: _buildSocialButton,
                      )
                    : SignUpView(
                        key: const ValueKey('signup'),
                        toggleAuthMode: _toggleAuthMode,
                        buildTextField: _buildTextField,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
