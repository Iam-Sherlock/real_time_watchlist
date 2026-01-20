

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  // FirebaseAuth instance = FirebaseAuth.instance;
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Simulate a network call
    try {
  final response = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  // await Future.delayed(Duration(seconds: 2));
  print('User signed in with email: $email is Success');
  return response.user != null;
} on Exception catch (e) {
  // TODO
  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed')),
                  );
                  return false;
}
  }
}
