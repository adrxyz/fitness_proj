import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🚨 Import for FirebaseAuthException
// Ensure you have these imports pointing to the correct paths
import 'package:fitness_proj/widgets/color_constant.dart'; 
import 'package:fitness_proj/auth/auth_service.dart'; // 🔑 Import the new service

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
  
  // 🔑 NEW: Instantiate the Auth Service
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. 🚀 LOGIN AND NAVIGATION LOGIC (NOW CALLS AUTH SERVICE)
  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    setState(() { _isLoading = true; });

    try {
      // 🔑 ACTUAL AUTH SERVICE CALL
      final User? user = await _authService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Crucial check: Exit if the widget was unmounted during the delay
      if (!mounted) return;
      
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome ${user.email}')),
        );
        
        // Crucial check before navigation
        if (!mounted) return;

        // 🔑 NAVIGATE TO UserProfileSetupScreen on success
        Navigator.of(context).pushReplacementNamed('/user-profile-setup');
      } 
    
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = 'Login failed.';
      
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      // General Error Handling
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red),
      );
    } finally {
      // We still need to call setState to stop loading indicator
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // 🌐 Helper function for social logins
  Future<void> _handleSocialLogin(Future<User?> Function() signInMethod, String provider) async {
    setState(() { _isLoading = true; });
    try {
      await signInMethod();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully signed in with $provider!')),
      );
      Navigator.of(context).pushReplacementNamed('/user-profile-setup');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$provider sign-in failed: ${e.message}'), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during $provider sign-in.'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
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
    // ... (This function remains largely the same, using the visibility state)
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
                  color: kAccentGold,
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
        labelStyle: TextStyle(color: kAccentGold),
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
                onPressed: _isLoading ? null : _submitLogin, // 🔑 Calls the real login logic
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
                style: const TextStyle(color: kOffWhite, fontSize: 14)
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 🔑 Google Login (Now uses the _handleSocialLogin helper)
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(_authService.signInWithGoogle, 'Google'),
                    child: widget.buildSocialButton(context, 'Google', Icons.g_mobiledata_rounded, kOffWhite),
                  ),
                  // Apple (using a placeholder function for simplicity)
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(() async => null, 'Apple'),
                    child: widget.buildSocialButton(context, 'Apple', Icons.apple_rounded, kOffWhite),
                  ),
                  // Facebook (using a placeholder function for simplicity)
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(() async => null, 'Facebook'),
                    child: widget.buildSocialButton(context, 'Facebook', Icons.facebook_rounded, Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Toggle to Sign Up
              Center(
                child: TextButton(
                  onPressed: widget.toggleAuthMode,
                  child: const Text(
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