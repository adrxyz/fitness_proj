// File: lib/auth/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

// Minimal AuthService for Email/Password Login and SignUp
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 📧 Email and Password Sign In
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      // Re-throw the exception so the calling widget can handle the specific error codes
      rethrow;
    } catch (e) {
      // Re-throw any other unexpected exceptions
      rethrow;
    }
  }

  // 🔑 NEW: Email and Password Sign Up
  /// Registers a new user with email and password.
  Future<User?> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Returns the newly created User object on success
      return userCredential.user;
    } on FirebaseAuthException {
      // Re-throw the exception so the SignUpView can catch and handle it
      rethrow;
    } catch (e) {
      // Re-throw any other unexpected exceptions
      rethrow;
    }
  }

  // 🌐 Placeholder for Social Sign-In (replace with real logic later)
  Future<User?> signInWithGoogle() async {
    // Implement real Google Sign-In logic here (requires google_sign_in package)
    throw FirebaseAuthException(
      code: 'social-not-implemented',
      message: 'Google Sign-In is a placeholder.',
    );
  }

  // 🚪 NEW: Sign Out
  /// Signs out the current user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}