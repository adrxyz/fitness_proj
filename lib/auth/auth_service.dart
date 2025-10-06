// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Error codes for a cleaner error handling in the UI
  static const String weakPassword = 'weak-password';
  static const String emailAlreadyInUse = 'email-already-in-use';

  /// Registers a new user with Firebase Authentication and saves
  /// additional profile data (full name, goal) to Firestore.
  Future<User?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    String? fitnessGoal,
  }) async {
    try {
      // 1. Create user in Firebase Authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Save additional user data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'fitnessGoal': fitnessGoal, // Can be null
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 3. Update the user's display name in Auth (optional, but good practice)
        await user.updateDisplayName(fullName);

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception so the UI can handle it
      throw e;
    } catch (e) {
      // General error handling
      print('Sign up error: $e');
      rethrow;
    }
  }
}