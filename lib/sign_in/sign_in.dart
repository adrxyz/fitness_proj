import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_proj/widgets/color_constant.dart';
import 'package:fitness_proj/auth/auth_service.dart';

// --- The original SignUpView definition ---
class SignUpView extends StatefulWidget {
  final VoidCallback toggleAuthMode;
  final Widget Function({required String labelText, required IconData icon, bool isPassword, TextInputType keyboardType}) buildTextField;

  const SignUpView({
    super.key,
    required this.toggleAuthMode,
    required this.buildTextField,
  });

  @override
  State<SignUpView> createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  // Controllers and Key for Form Management
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Service Instance
  final AuthService _authService = AuthService();

  String? selectedGoal;
  final List<String> fitnessGoals = ['Lose weight', 'Build muscle', 'Stay active'];
  bool _isLoading = false;

  // 🔑 NEW STATE VARIABLES for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🚀 ASYNCHRONOUS SIGN-UP LOGIC (No change needed here, just for context)
  Future<void> _submitSignUp() async {
    // 1. Validation and Password Match Check
    if (!_formKey.currentState!.validate() || _passwordController.text != _confirmPasswordController.text) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // 2. Call the Auth Service (Backend)
      await _authService.signUpWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        fitnessGoal: selectedGoal,
      );

      // 3. Handle Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created! Welcome, ${_fullNameController.text}.'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigation to login after successful sign up
      Navigator.of(context).pushReplacementNamed('/login');
      
    } on FirebaseAuthException catch (e) {
      // 4. Handle Specific Firebase Exceptions
      String errorMessage = 'Sign Up failed. Please try again.';
      
      if (e.code == AuthService.emailAlreadyInUse) {
        errorMessage = 'This email is already registered. Try logging in.';
      } else if (e.code == AuthService.weakPassword) {
        errorMessage = 'The password is too weak. Choose a stronger one.';
      } else {
        // Fallback for other codes (e.g., network error)
        errorMessage = 'Firebase Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      // 5. Handle General Errors (e.g., Firestore write failure)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Validated Text Field Helper (MODIFIED to include suffixIcon)
  Widget _buildValidatedTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon, // 🔑 ADDED: Optional suffix icon
    bool obscureText = false, // 🔑 ADDED: Obscure text control
  }) {
    // Replicates the styling from your original widget.buildTextField but uses TextFormField
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText, // 🔑 USE the new obscureText parameter
      style: const TextStyle(color: kOffWhite),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: kAccentGold),
        suffixIcon: suffixIcon, // 🔑 INSERT the optional suffix icon
        filled: true,
        fillColor: kDarkGrey.withOpacity(0.7),
        labelStyle: TextStyle(color: kAccentGold.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentGold, width: 2),
        ),
        errorStyle: const TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
      ),
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
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
        child: Form( // 🔑 Form widget for validation
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

              // Full Name
              _buildValidatedTextField(
                labelText: 'Full Name', 
                icon: Icons.person_rounded, 
                controller: _fullNameController
              ),
              const SizedBox(height: 16),

              // Email Address
              _buildValidatedTextField(
                labelText: 'Email Address', 
                icon: Icons.email_rounded, 
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
                validator: (value) => (value == null || value.length < 6) ? 'Password must be 6+ characters' : null,
                suffixIcon: _buildVisibilityToggle(
                  isVisible: _isPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password Field (with toggle)
              _buildValidatedTextField(
                labelText: 'Confirm Password', 
                icon: Icons.lock_open_rounded, 
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: !_isConfirmPasswordVisible, // 🔑 Use visibility state
                validator: (value) => (value != _passwordController.text) ? 'Passwords do not match' : null,
                suffixIcon: _buildVisibilityToggle(
                  isVisible: _isConfirmPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ... Fitness Goals Section ...
              Text(
                'Your Fitness Goal (Optional)',
                style: TextStyle(
                  color: kPrimaryMaroon.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: fitnessGoals.map((goal) {
                  bool isSelected = selectedGoal == goal;
                  return ChoiceChip(
                    label: Text(goal),
                    selected: isSelected,
                    selectedColor: kPrimaryMaroon,
                    backgroundColor: kDarkGrey.withOpacity(0.7),
                    labelStyle: TextStyle(
                      color: isSelected ? kOffWhite : kOffWhite.withOpacity(0.7),
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
                  onPressed: _isLoading ? null : _submitSignUp, // Call the integrated function
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
                          child: CircularProgressIndicator(color: kOffWhite, strokeWidth: 3), // Show loading
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