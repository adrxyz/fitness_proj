import 'package:flutter/material.dart';
// 🚨 Ensure you have this import for navigation
// import 'package:fitness_proj/screens/user_profile_setup_screen.dart'; 
import 'package:fitness_proj/widgets/color_constant.dart';
// NOTE: I've removed the Firebase/AuthService imports to simplify the minimal fix
// but in a real app, you would need them here.

// 1. CONVERTED TO STATEFULWIDGET
class LoginView extends StatefulWidget {
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
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // 2. Add Controllers and Key for proper form handling
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. 🚀 LOGIN AND NAVIGATION LOGIC
  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    setState(() { _isLoading = true; });

    // ⚠️ PLACEHOLDER FOR ACTUAL AUTH SERVICE CALL
    try {
      // Simulate network/login delay (Replace with your AuthService call)
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate a successful login result
      bool loginSuccess = true; 

      if (loginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful! Redirecting...')),
        );
        
        // 🔑 KEY FIX: NAVIGATE TO UserProfileSetupScreen
        // pushReplacementNamed prevents the user from going back to the login screen
        // using the back button after successful login.
        Navigator.of(context).pushReplacementNamed('/user-profile-setup');
        
      } 

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Helper to apply styling from the parent widget to a TextFormField with validation
  Widget _buildValidatedTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? !_isPasswordVisible : false,
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: kAccentGold),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: kAccentGold.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: kDarkGrey,
        labelStyle: TextStyle(color: kAccentGold.withOpacity(0.8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kAccentGold, width: 2)),
        errorStyle: const TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
      ),
      style: const TextStyle(color: kOffWhite),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form( // 🔑 Wrap content in a Form
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kPrimaryMaroon),
              ),
              const SizedBox(height: 24),

              // Email Field
              _buildValidatedTextField(
                labelText: 'Email Address',
                icon: Icons.email_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || !value.contains('@')) ? 'Invalid email format' : null,
              ),
              const SizedBox(height: 16),
              
              // Password Field
              _buildValidatedTextField(
                labelText: 'Password',
                icon: Icons.lock_rounded,
                controller: _passwordController,
                isPassword: true,
                validator: (value) => (value == null || value.isEmpty) ? 'Password is required' : null,
              ),
              const SizedBox(height: 24),

              // Main Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitLogin, // 🔑 Use the logic function
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryMaroon,
                  foregroundColor: kOffWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: kOffWhite, strokeWidth: 3),
                      ) 
                    : const Text('SIGN IN'),
              ),
              const SizedBox(height: 24),
              
              // Social Login Options
              Text(
                '— OR SIGN IN WITH —', 
                textAlign: TextAlign.center, 
                style: TextStyle(color: kOffWhite, fontSize: 14)
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.buildSocialButton(context, 'Google', Icons.g_mobiledata_rounded, kOffWhite),
                  widget.buildSocialButton(context, 'Apple', Icons.apple_rounded, kOffWhite),
                  widget.buildSocialButton(context, 'Facebook', Icons.facebook_rounded, Colors.blue),
                ],
              ),
              const SizedBox(height: 24),

              // Toggle to Sign Up
              Center(
                child: TextButton(
                  onPressed: widget.toggleAuthMode,
                  child: Text(
                    'Don\'t have an account? Sign Up!',
                    style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}