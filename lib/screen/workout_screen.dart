import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

// Placeholder for the live workout screen (to navigate to when "START" is pressed)
class LiveWorkoutScreen extends StatelessWidget {
  const LiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNearBlack,
      appBar: AppBar(
        title: const Text('LIVE SESSION', style: TextStyle(color: kAccentGold)),
        backgroundColor: kNearBlack,
      ),
      body: Center(
        child: Text('This is the live workout screen (like the Reverse Lunge image)!', 
          style: TextStyle(color: kOffWhite, fontSize: 18)),
      ),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Mock Data reflecting the scheduled workout view
  String _currentWorkoutTitle = "TUESDAY'S WORKOUT";
  String _workoutType = "Full Body";
  String _workoutWeek = "Week 1/5 - Foundations";

  final List<Map<String, dynamic>> _currentExercises = [
    {
      'name': 'Smith Machine Squat',
      'image': 'assets/images/smith_machine_squat.jpg', // Placeholder asset
      'sets_reps': '4 sets x 6-8 reps x 50 lb',
      'isCompleted': false,
    },
    {
      'name': 'Barbell Good Morning',
      'image': 'assets/images/barbell_good_morning.jpg', // Placeholder asset
      'sets_reps': '3 sets x 10 reps x 75 lb',
      'isCompleted': false,
    },
    {
      'name': 'Dumbbell Bench Press',
      'image': 'assets/images/db_bench_press.jpg', // Placeholder asset
      'sets_reps': '4 sets x 8 reps x 30 lb',
      'isCompleted': false,
    },
    {
      'name': 'Seated Cable Row',
      'image': 'assets/images/cable_row.jpg', // Placeholder asset
      'sets_reps': '3 sets x 12 reps',
      'isCompleted': false,
    },
  ];

  void _startWorkout() {
    // Navigate to the live workout execution screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LiveWorkoutScreen(),
      ),
    );
  }

  void _editWorkout() {
    print("Editing the current workout sequence.");
    // Implementation for a bottom sheet or new page to reorder/edit exercises
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNearBlack,
      appBar: AppBar(
        title: const Text(
          'FORGE WORKOUT',
          style: TextStyle(color: kAccentGold, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        backgroundColor: kNearBlack,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: kOffWhite),
            onPressed: () { /* navigate to workout filters/options */ },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Filters and Calendar
          _buildFiltersAndCalendar(),

          // 2. Workout Header Card (TUESDAY'S WORKOUT)
          _buildWorkoutHeaderCard(),

          // 3. Exercises List (Expanded view of the planned exercises)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              itemCount: _currentExercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(_currentExercises[index]);
              },
            ),
          ),

          // 4. START WORKOUT Button
          _buildStartButton(),
        ],
      ),
    );
  }

  // --- NEW WIDGET BUILDERS ---

  Widget _buildFiltersAndCalendar() {
    // Mimics the filter dropdowns and calendar dates from the image
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Filter Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdownFilter('Muscles (7)', Icons.arrow_drop_down),
              _buildDropdownFilter('30-45 Min', Icons.arrow_drop_down),
              _buildDropdownFilter('3 Workout Days', Icons.arrow_drop_down),
            ],
          ),
          const SizedBox(height: 10),

          // Calendar Strip (Mo to Su)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final day = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'][index];
              final date = (27 + index).toString();
              final isToday = day == 'Tu'; 
              
              return Column(
                children: [
                  Text(day, style: TextStyle(color: isToday ? kAccentGold : kOffWhite.withOpacity(0.6), fontSize: 13)),
                  const SizedBox(height: 4),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday ? kPrimaryMaroon : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday ? Border.all(color: kAccentGold, width: 1) : null,
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: kOffWhite,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: kAccentGold, shape: BoxShape.circle),
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kDarkGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: kOffWhite.withOpacity(0.8), fontSize: 13)),
          Icon(icon, color: kOffWhite.withOpacity(0.8), size: 18),
        ],
      ),
    );
  }

  Widget _buildWorkoutHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kPrimaryMaroon, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week/Foundation Text
          Text(
            _workoutWeek,
            style: TextStyle(color: kPrimaryMaroon.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Workout Title and Edit Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentWorkoutTitle,
                style: const TextStyle(color: kOffWhite, fontSize: 24, fontWeight: FontWeight.w900),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: kAccentGold),
                onPressed: _editWorkout,
              ),
            ],
          ),
          Text(
            _workoutType,
            style: TextStyle(color: kOffWhite.withOpacity(0.7), fontSize: 16),
          ),
          const Divider(color: kPrimaryMaroon, height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatDetail('4', 'Exercises', Icons.bolt),
              _buildStatDetail('39', 'Min', Icons.timer),
              _buildStatDetail('207', 'Cal', Icons.local_fire_department),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kAccentGold, size: 18),
        const SizedBox(width: 5),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(color: kOffWhite, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextSpan(
                text: ' $label',
                style: TextStyle(color: kOffWhite.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    // The main workout preview card, like the Smith Machine Squat example
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kNearBlack.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Video/Image Area
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  exercise['image'], 
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  // Fallback for missing asset
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: kNearBlack,
                      child: Center(child: Text(
                        'Video Unavailable', 
                        style: TextStyle(color: kPrimaryMaroon.withOpacity(0.7))
                      )),
                    );
                  },
                ),
              ),
              
              // Bottom-left info chip
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise['sets_reps'],
                    style: const TextStyle(color: kOffWhite, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // Exercise Name and Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['name'],
                      style: const TextStyle(color: kAccentGold, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Target: Legs, Glutes', // Static for this example
                      style: TextStyle(color: kOffWhite.withOpacity(0.7), fontSize: 12),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: kPrimaryMaroon, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    // Styled to look like the large yellow button in the image
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ElevatedButton(
        onPressed: _startWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentGold,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: kPrimaryMaroon, width: 2) // Added a maroon border for definition
          ),
          elevation: 10,
          shadowColor: kAccentGold.withOpacity(0.5),
        ),
        child: const Text(
          'START WORKOUT',
          style: TextStyle(
            color: kNearBlack,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}