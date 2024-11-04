import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVerified = false;
  bool isLoading = false;

  Future<void> checkEmailVerified(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    User? user = _auth.currentUser;
    await user!.reload();
    user = _auth.currentUser;

    if (user!.emailVerified) {
      isVerified = true;
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
