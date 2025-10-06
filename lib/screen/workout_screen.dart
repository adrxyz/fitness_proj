import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';
import 'package:fitness_proj/model/exercise.dart'; // NEW IMPORT
import 'package:fitness_proj/service/workout_sevice.dart'; // NEW IMPORT

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
  // Initialize the service
  final WorkoutService _workoutService = WorkoutService();

  // Data now fetched from the service (or a state management solution later)
  late String _currentWorkoutTitle;
  late String _workoutType;
  late String _workoutWeek;
  late List<Exercise> _currentExercises; // CHANGED TYPE

  @override
  void initState() {
    super.initState();
    // Initialize data using the service
    _currentWorkoutTitle = _workoutService.getCurrentWorkoutTitle();
    _workoutType = _workoutService.getWorkoutType();
    _workoutWeek = _workoutService.getWorkoutWeek();
    _currentExercises = _workoutService.getCurrentWorkout(); // Data is now a list of Exercise objects
  }

  void _startWorkout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LiveWorkoutScreen(),
      ),
    );
  }

  void _editWorkout() {
    print("Editing the current workout sequence.");
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
          _buildFiltersAndCalendar(), // Method call is here

          // 2. Workout Header Card (TUESDAY'S WORKOUT)
          _buildWorkoutHeaderCard(),

          // 3. Exercises List (Expanded view of the planned exercises)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              itemCount: _currentExercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(_currentExercises[index]); // Pass Exercise object
              },
            ),
          ),

          // 4. START WORKOUT Button
          _buildStartButton(),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  // RE-INSERTED METHOD: _buildFiltersAndCalendar
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
                  Text(day, style: TextStyle(color: isToday ? kAccentGold : kOffWhite, fontSize: 13)), // REMOVED .withOpacity(0.6)
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
  
  // RE-INSERTED METHOD: _buildDropdownFilter
  Widget _buildDropdownFilter(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kDarkGrey, // REMOVED .withOpacity(0.5)
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: kOffWhite, fontSize: 13)), // REMOVED .withOpacity(0.8)
          Icon(icon, color: kOffWhite, size: 18), // REMOVED .withOpacity(0.8)
        ],
      ),
    );
  }

  // RE-INSERTED METHOD: _buildWorkoutHeaderCard
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
            style: TextStyle(color: kPrimaryMaroon, fontSize: 12, fontWeight: FontWeight.bold), // REMOVED .withOpacity(0.9)
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
            style: TextStyle(color: kOffWhite, fontSize: 16), // REMOVED .withOpacity(0.7)
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

  // RE-INSERTED METHOD: _buildStatDetail
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
                style: TextStyle(color: kOffWhite, fontSize: 14), // REMOVED .withOpacity(0.7)
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // MODIFIED: Takes an Exercise object instead of a Map
  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kNearBlack, // REMOVED .withOpacity(0.3)
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
                  exercise.image, // Use the object property
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: kNearBlack,
                      child: Center(child: Text(
                        'Video Unavailable', 
                        style: TextStyle(color: kPrimaryMaroon) // REMOVED .withOpacity(0.7)
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
                    color: Colors.black, // REMOVED .withOpacity(0.7)
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise.setsReps, // Use the object property
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
                      exercise.name, // Use the object property
                      style: const TextStyle(color: kAccentGold, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Target: ${exercise.targetMuscles}', // Use the object property
                      style: TextStyle(color: kOffWhite, fontSize: 12), // REMOVED .withOpacity(0.7)
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

  // RE-INSERTED METHOD: _buildStartButton
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
          shadowColor: kAccentGold, // REMOVED .withOpacity(0.5)
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
