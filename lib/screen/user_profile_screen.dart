import 'package:flutter/material.dart';
import 'package:fitness_proj/model/userdata.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

const List<String> genders = ['Male', 'Female', 'Other'];
const List<String> activityLevels = ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active'];
const List<String> workoutPreferences = ['Yoga', 'Cardio', 'Strength', 'HIIT', 'Flexibility'];

class UserProfileSetupScreen extends StatefulWidget {
  const UserProfileSetupScreen({super.key});

  @override
  State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final UserData _userData = UserData();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 2; // Biometrics + Preferences

  // Form Key for Step 1 validation
  final _formKeyStep1 = GlobalKey<FormState>();

  void _nextPage() {
    if (_currentPage == 0 && !_formKeyStep1.currentState!.validate()) {
      return;
    }
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Final step submission
      _submitProfile();
    }
  }

  void _submitProfile() {
    // In a real app, this is where you would save _userData to Firebase/API
    print("--- User Profile Submitted ---");
    print("Height: ${_userData.height} cm");
    print("Weight: ${_userData.weight} kg");
    print("Age: ${_userData.age}");
    print("Gender: ${_userData.gender}");
    print("Activity Level: ${_userData.activityLevel}");
    print("Preferences: ${_userData.preferences.join(', ')}");

    // Navigate away
    Navigator.pop(context); // Go back to the main app screen (or home screen)
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile', style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold)),
        backgroundColor: kNearBlack,
        iconTheme: const IconThemeData(color: kOffWhite),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _numPages,
              backgroundColor: kDarkGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(kAccentGold),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          
          // Page View for Steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _buildBiometricsStep(),
                _buildPreferencesStep(),
              ],
            ),
          ),

          // Control Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentGold,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentPage == _numPages - 1 ? "FINISH SETUP" : "CONTINUE",
                style: const TextStyle(color: kNearBlack, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Biometrics Form ---

  Widget _buildBiometricsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tell Us About Yourself",
              style: TextStyle(color: kOffWhite, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This data helps us create your personalized training roadmap.",
              style: TextStyle(color: kOffWhite, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Age
            _buildNumberInputField(
              label: 'Age',
              hint: 'Enter your age',
              onChanged: (value) => _userData.age = int.tryParse(value) ?? 0,
            ),
            const SizedBox(height: 20),

            // Height (cm)
            _buildNumberInputField(
              label: 'Height (cm)',
              hint: 'e.g., 175',
              onChanged: (value) => _userData.height = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 20),

            // Weight (kg)
            _buildNumberInputField(
              label: 'Weight (kg)',
              hint: 'e.g., 75.5',
              onChanged: (value) => _userData.weight = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 20),

            // Gender
            _buildDropdownField(
              label: 'Gender',
              value: _userData.gender,
              items: genders,
              onChanged: (String? newValue) {
                setState(() {
                  _userData.gender = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 2: Preferences Form ---

  Widget _buildPreferencesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Set Your Fitness Goals",
            style: TextStyle(color: kOffWhite, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your choices here will guide our suggested workouts and plans.",
            style: TextStyle(color: kOffWhite, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Activity Level
          _buildDropdownField(
            label: 'Activity Level',
            value: _userData.activityLevel,
            items: activityLevels,
            onChanged: (String? newValue) {
              setState(() {
                _userData.activityLevel = newValue!;
              });
            },
          ),
          const SizedBox(height: 32),

          // Workout Preferences (Multi-select)
          const Text(
            "Workout Focus (Select all that apply):",
            style: TextStyle(color: kOffWhite, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: workoutPreferences.map((preference) {
              final isSelected = _userData.preferences.contains(preference);
              return FilterChip(
                label: Text(preference, style: TextStyle(color: isSelected ? kNearBlack : kOffWhite)),
                selected: isSelected,
                backgroundColor: kDarkGrey,
                selectedColor: kAccentGold,
                checkmarkColor: kNearBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? kAccentGold : kOffWhite.withOpacity(0.5)),
                ),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _userData.preferences.add(preference);
                    } else {
                      _userData.preferences.remove(preference);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
    Widget _buildNumberInputField({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: kOffWhite, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: kOffWhite),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kOffWhite.withOpacity(0.5)),
            filled: true,
            fillColor: kDarkGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty || double.tryParse(value) == null) {
              return 'Please enter a valid number for $label.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: kOffWhite, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: kDarkGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          dropdownColor: kDarkGrey,
          style: const TextStyle(color: kOffWhite, fontSize: 16),
          icon: const Icon(Icons.arrow_drop_down, color: kAccentGold),
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
