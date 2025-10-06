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

  // 🚀 ADDED METHOD: SIGN IN (Login) 🚀
  /// Signs in a user with Firebase Authentication.
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception so the LoginView can handle specific codes
      throw e;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // 🌐 ADDED PLACEHOLDER METHODS for Social Logins
  Future<User?> signInWithGoogle() async {
    // 💡 TODO: Implement actual Google Sign-In logic here
    throw UnimplementedError('Google Sign-In is not fully implemented.');
  }

  Future<User?> signInWithApple() async {
    // 💡 TODO: Implement actual Apple Sign-In logic here
    throw UnimplementedError('Apple Sign-In is not fully implemented.');
  }

  Future<User?> signInWithFacebook() async {
    // 💡 TODO: Implement actual Facebook Sign-In logic here
    throw UnimplementedError('Facebook Sign-In is not fully implemented.');
  }
}