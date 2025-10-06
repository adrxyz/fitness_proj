// lib/models/exercise.dart

class Exercise {
  final String name;
  final String image;
  final String setsReps;
  final bool isCompleted;
  final String targetMuscles; // Added for the static detail in the card

  const Exercise({
    required this.name,
    required this.image,
    required this.setsReps,
    required this.isCompleted,
    required this.targetMuscles,
  });

  // Factory constructor to convert the mock Map data into a strongly-typed Exercise object
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',
      image: map['image'] ?? 'assets/images/placeholder.jpg',
      setsReps: map['sets_reps'] ?? 'N/A',
      isCompleted: map['isCompleted'] ?? false,
      targetMuscles: map['targetMuscles'] ?? 'N/A', // Assuming you'll add this to the mock data
    );
  }
}