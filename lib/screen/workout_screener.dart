import 'package:flutter/material.dart';

class WorkoutScreener extends StatefulWidget {
  @override
  _WorkoutScreenerState createState() => _WorkoutScreenerState();
}

class _WorkoutScreenerState extends State<WorkoutScreener> {
  // 1. User Goal
  String? _selectedGoal;
  final List<String> _goals = ['Build Muscle', 'Lose Weight', 'Improve Endurance', 'General Health'];

  // 2. Fitness Level
  String? _selectedLevel;
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];

  // 3. Activity Frequency
  int _workoutDays = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell Us About You'),
        automaticallyImplyLeading: false, // Hide back button for a flow start
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Goal Section ---
            const Text('What is your main fitness goal?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _goals.map((goal) => ChoiceChip(
                label: Text(goal),
                selected: _selectedGoal == goal,
                onSelected: (selected) {
                  setState(() {
                    _selectedGoal = selected ? goal : null;
                  });
                },
              )).toList(),
            ),
            
            const Divider(height: 40),

            // --- Level Section ---
            const Text('What is your current fitness level?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: _levels.map((level) => RadioListTile<String>(
                title: Text(level),
                value: level,
                groupValue: _selectedLevel,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
              )).toList(),
            ),

            const Divider(height: 40),

            // --- Frequency Section ---
            const Text('How many days a week can you train?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_workoutDays days', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: _workoutDays.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    label: _workoutDays.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _workoutDays = value.round();
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // --- Continue Button ---
            ElevatedButton(
              onPressed: _isFormValid() ? _submitScreener : null, // Disable button until choices are made
              child: const Text('Create My Plan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple validation check
  bool _isFormValid() {
    return _selectedGoal != null && _selectedLevel != null;
  }

  // Action on submit
  void _submitScreener() {
    // 1. Save data (e.g., using shared preferences, Hive, or a database)
    print('Goal: $_selectedGoal, Level: $_selectedLevel, Days: $_workoutDays');

    // 2. Navigate to the main app dashboard
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => const MainDashboard()),
    // );

    // For now, show a simple success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan created! Welcome to the app.')),
    );
  }
}