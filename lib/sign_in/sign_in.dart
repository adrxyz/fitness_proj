import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🚨 Import for Firebase error handling
// Ensure these paths are correct
import 'package:fitness_proj/widgets/color_constant.dart';
import 'package:fitness_proj/auth/auth_service.dart'; // 🔑 Import the Auth Service


class SignUpView extends StatefulWidget {
  final VoidCallback toggleAuthMode;
  // NOTE: The signature of buildTextField is too simple for full form validation/controllers.
  // We will rewrite the text fields using a helper function to enforce validation.
  final Widget Function({required String labelText, required IconData icon, bool isPassword, TextInputType keyboardType}) buildTextField;

  const SignUpView({
    super.key,
    required this.toggleAuthMode,
    required this.buildTextField,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState(); // Fixed to use the private state class name
}

class _SignUpViewState extends State<SignUpView> {
  // 🔑 1. Controllers, Key, and Service Instance
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final AuthService _authService = AuthService(); // Instantiate service
  
  String? selectedGoal;
  final List<String> fitnessGoals = ['Lose weight', 'Build muscle', 'Stay active'];
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🚀 2. Sign Up Logic
  Future<void> _submitSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    setState(() { _isLoading = true; });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      // 🔑 ACTUAL AUTH SERVICE CALL
      final User? user = await _authService.signUpWithEmailPassword(
        email: email,
        password: password,
      );
      
      if (!mounted) return;
      
      if (user != null) {
        // NOTE: In a real app, you'd save the FullName and Goal to Firestore/database here
        // user.updateDisplayName(_fullNameController.text);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created for ${user.email}! Goal: ${selectedGoal ?? 'N/A'}')),
        );
        
        if (!mounted) return;
        
        // Navigate to the next screen (e.g., UserProfileSetupScreen)
        Navigator.of(context).pushReplacementNamed('/login'); 
      } 
    
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = 'Sign Up failed.';
      
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // 🛠️ 3. Validated Text Field Helper (copied/adapted from LoginView)
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
        // 🔑 4. Wrap with Form widget
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kPrimaryMaroon),
              ),
              const SizedBox(height: 24),

              // Full Name Field
              _buildValidatedTextField(
                labelText: 'Full Name',
                icon: Icons.person_rounded,
                controller: _fullNameController,
              ),
              const SizedBox(height: 16),
              
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
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Confirm Password Field
              _buildValidatedTextField(
                labelText: 'Confirm Password',
                icon: Icons.lock_open_rounded,
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Fitness Goals Section ---
              Text(
                'Your Fitness Goal (Optional)',
                style: TextStyle(
                  color: kPrimaryMaroon,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Goal Choice Chips
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: fitnessGoals.map((goal) {
                  bool isSelected = selectedGoal == goal;
                  return ChoiceChip(
                    label: Text(goal),
                    selected: isSelected,
                    selectedColor: kPrimaryMaroon,
                    backgroundColor: kDarkGrey,
                    labelStyle: TextStyle(
                      color: isSelected ? kOffWhite : kOffWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedGoal = selected ? goal : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSignUp, // 🔑 Call the backend function
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
                    : const Text('CREATE ACCOUNT'),
                ),
              ),
              const SizedBox(height: 16),

              // Toggle to Login
              Center(
                child: TextButton(
                  onPressed: widget.toggleAuthMode,
                  child: Text(
                    'Already have an account? Login',
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