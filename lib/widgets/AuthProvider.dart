import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String errorMessage = '';
  bool isLoading = false;

  AuthProvider() {
    // الاستماع لتغييرات حالة المستخدم
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // تحديث حالة المستخدم عند التغيير
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = ''; // Reset the error message
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // التحقق من أن البريد الإلكتروني تم التحقق منه
      if (userCredential.user!.emailVerified) {
        errorMessage = ''; // Reset error message if login is successful
      } else {
        errorMessage = "يرجى التحقق من بريدك الإلكتروني.";
      }
    } on FirebaseAuthException catch (e) {
      // التعامل مع أخطاء المصادقة المحددة من Firebase
      if (e.code == 'user-not-found') {
        errorMessage = "لا يوجد مستخدم بهذا البريد الإلكتروني.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "كلمة المرور غير صحيحة.";
      } else {
        errorMessage = "خطأ في تسجيل الدخول: ${e.message}";
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
