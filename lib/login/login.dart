import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

class LoginView extends StatelessWidget {
  final VoidCallback toggleAuthMode;
  final Widget Function({required String labelText, required IconData icon, bool isPassword, TextInputType keyboardType}) buildTextField;
  final Widget Function(BuildContext context, String label, IconData icon, Color color) buildSocialButton;

  const LoginView({
    super.key,
    required this.toggleAuthMode,
    required this.buildTextField,
    required this.buildSocialButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kPrimaryMaroon),
            ),
            const SizedBox(height: 24),

            // Email & Password Fields
            buildTextField(
              labelText: 'Email Address',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            buildTextField(
              labelText: 'Password',
              icon: Icons.lock_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 24),

            // Main Login Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attempting Email/Password Login...')),
                );
              },
              child: const Text('SIGN IN'),
            ),
            const SizedBox(height: 24),
            
            // Social Login Options
            Text(
              '— OR SIGN IN WITH —', 
              textAlign: TextAlign.center, 
              style: TextStyle(color: kOffWhite.withOpacity(0.7), fontSize: 14)
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSocialButton(context, 'Google', Icons.g_mobiledata_rounded, kOffWhite),
                buildSocialButton(context, 'Apple', Icons.apple_rounded, kOffWhite),
                buildSocialButton(context, 'Facebook', Icons.facebook_rounded, Colors.blue),
              ],
            ),
            const SizedBox(height: 24),

            // Toggle to Sign Up
            TextButton(
              onPressed: toggleAuthMode,
              child: Text(
                'Don\'t have an account? Sign Up!',
                style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}