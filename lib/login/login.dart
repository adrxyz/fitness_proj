import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuthException
import 'package:fitness_proj/widgets/color_constant.dart';
// 🚨 Import your service using the package path
import 'package:fitness_proj/auth/auth_service.dart';

// --- 1. Convert to StatefulWidget ---
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
  // 2. Form Key and Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 3. Service Instance and State
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  // 🔑 NEW STATE: Password visibility toggle
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 4. 🚀 EMAIL/PASSWORD LOGIN LOGIC
  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    setState(() { _isLoading = true; });

    try {
      // Call the Auth Service
      final User? user = await _authService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Handle Success
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back!')),
        );
        // 💡 Navigate to the home screen after successful login
        // Replace '/home' with your actual home screen route
        Navigator.of(context).pushReplacementNamed('/home'); 
      }

    } on FirebaseAuthException catch (e) {
      // Handle Specific Firebase Exceptions
      String errorMessage = 'Login failed.';
      
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts. Try again later.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      // General Error Handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // 5. 🌐 SOCIAL LOGIN LOGIC (No change needed here)
  Future<void> _handleSocialLogin(Future<User?> Function() signInMethod, String provider) async {
    setState(() { _isLoading = true; });
    try {
      await signInMethod();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully signed in with $provider!')),
      );
      // 💡 TODO: Navigate to the home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$provider sign-in failed: ${e.message}'), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during $provider sign-in.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // 6. 🛠️ VALIDATED TEXT FIELD HELPER (Modified to support suffixIcon and explicit obscureText)
  Widget _buildValidatedTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon, // 🔑 ADDED: Optional suffix icon
    required bool obscureText, // 🔑 MODIFIED: Explicit obscure text control
  }) {
    // NOTE: This relies on the styling being defined locally for consistency
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText, // 🔑 USE the explicit obscureText parameter
      // Apply validator checks
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: kAccentGold),
        suffixIcon: suffixIcon, // 🔑 INSERT the optional suffix icon
        filled: true,
        fillColor: kDarkGrey.withOpacity(0.7),
        labelStyle: TextStyle(color: kAccentGold.withOpacity(0.8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kAccentGold, width: 2)),
        errorStyle: const TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
      ),
      style: const TextStyle(color: kOffWhite),
    );
  }

  // 🔑 HELPER FUNCTION to create the visibility toggle button
  Widget _buildVisibilityToggle({required bool isVisible, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: kAccentGold.withOpacity(0.7),
      ),
      onPressed: onPressed,
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
                obscureText: false, // Email is never obscured
                validator: (value) => (value == null || !value.contains('@')) ? 'Invalid email format' : null,
              ),
              const SizedBox(height: 16),
              
              // Password Field (with toggle)
              _buildValidatedTextField(
                labelText: 'Password',
                icon: Icons.lock_rounded,
                controller: _passwordController,
                isPassword: true,
                obscureText: !_isPasswordVisible, // 🔑 Use visibility state
                validator: (value) => (value == null || value.isEmpty) ? 'Password is required' : null,
                suffixIcon: _buildVisibilityToggle(
                  isVisible: _isPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Main Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitLogin, // Call the backend function
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
                style: TextStyle(color: kOffWhite.withOpacity(0.7), fontSize: 14)
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(_authService.signInWithGoogle, 'Google'),
                    child: widget.buildSocialButton(context, 'Google', Icons.g_mobiledata_rounded, kOffWhite),
                  ),
                  // Apple (Assuming you have signInWithApple in AuthService)
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(() async => null, 'Apple'), // Placeholder method
                    child: widget.buildSocialButton(context, 'Apple', Icons.apple_rounded, kOffWhite),
                  ),
                  // Facebook (Assuming you have signInWithFacebook in AuthService)
                  InkWell(
                    onTap: _isLoading ? null : () => _handleSocialLogin(() async => null, 'Facebook'), // Placeholder method
                    child: widget.buildSocialButton(context, 'Facebook', Icons.facebook_rounded, Colors.blue),
                  ),
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