
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Updated to use authStateChanges()
  final Stream<User?> stream = FirebaseAuth.instance.authStateChanges();

  Future<void> login({required String email, required String password}) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    print(result);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> getToken() async {
// Updated to directly access currentUser, which is now a property
    User? user = _auth.currentUser;
    if (user != null) {
// Since getIdToken() returns a TokenResult, which directly contains the token as a string
      return await user.getIdToken();
    }
    return null; // Return null if there is no current user
  }
}
