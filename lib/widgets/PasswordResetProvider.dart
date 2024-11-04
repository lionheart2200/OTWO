import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String message = '';
  bool isLoading = false;

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      message = "Please enter your email address.";
      notifyListeners();
      return;
    }

    isLoading = true;
    message = '';
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      message = "Password reset email sent! Please check your inbox.";
    } catch (e) {
      message = "Error: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
