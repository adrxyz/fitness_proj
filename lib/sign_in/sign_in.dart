import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

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
  String? selectedGoal;
  final List<String> fitnessGoals = ['Lose weight', 'Build muscle', 'Stay active'];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kOffWhite),
            ),
            const SizedBox(height: 24),

            // User Info Fields
            widget.buildTextField(
              labelText: 'Full Name',
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: 16),
            widget.buildTextField(
              labelText: 'Email Address',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            widget.buildTextField(
              labelText: 'Password',
              icon: Icons.lock_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            widget.buildTextField(
              labelText: 'Confirm Password',
              icon: Icons.lock_open_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 24),

            // --- Fitness Goals Section ---
            Text(
              'Your Fitness Goal (Optional)',
              style: TextStyle(
                color: kOffWhite.withOpacity(0.8),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Account created! Goal: ${selectedGoal ?? 'Not selected'}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('CREATE ACCOUNT'),
              ),
            ),
            const SizedBox(height: 16),

            // Toggle to Login
            TextButton(
              onPressed: widget.toggleAuthMode,
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
