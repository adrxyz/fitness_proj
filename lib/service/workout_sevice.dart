// lib/services/workout_service.dart
import '../../model/exercise.dart';

// This is where your mock data is now stored
final List<Map<String, dynamic>> _mockExercisesData = [
  {
    'name': 'Smith Machine Squat',
    'image': 'assets/images/smith_machine_squat.jpg',
    'sets_reps': '4 sets x 6-8 reps x 50 lb',
    'isCompleted': false,
    'targetMuscles': 'Legs, Glutes',
  },
  {
    'name': 'Barbell Good Morning',
    'image': 'assets/images/barbell_good_morning.jpg',
    'sets_reps': '3 sets x 10 reps x 75 lb',
    'isCompleted': false,
    'targetMuscles': 'Hamstrings, Lower Back',
  },
  {
    'name': 'Dumbbell Bench Press',
    'image': 'assets/images/db_bench_press.jpg',
    'sets_reps': '4 sets x 8 reps x 30 lb',
    'isCompleted': false,
    'targetMuscles': 'Chest, Triceps',
  },
  {
    'name': 'Seated Cable Row',
    'image': 'assets/images/cable_row.jpg',
    'sets_reps': '3 sets x 12 reps',
    'isCompleted': false,
    'targetMuscles': 'Back, Biceps',
  },
];

class WorkoutService {
  // Method to fetch the workout exercises
  // In a real app, this would be an async function calling an API/Firebase
  List<Exercise> getCurrentWorkout() {
    return _mockExercisesData.map((data) => Exercise.fromMap(data)).toList();
  }

  // You can add more mock data here if needed
  String getCurrentWorkoutTitle() => "TUESDAY'S WORKOUT";
  String getWorkoutType() => "Full Body";
  String getWorkoutWeek() => "Week 1/5 - Foundations";
}