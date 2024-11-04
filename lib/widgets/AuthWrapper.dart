// auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:otwo/widgets/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:otwo/HomePage.dart';
import 'package:otwo/auth/LoginPage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const HomePage(); // إذا كان المستخدم مسجلًا الدخول، يعرض الصفحة الرئيسية
    } else {
      return const LoginPage(); // إذا لم يكن المستخدم مسجلًا الدخول، يعرض صفحة تسجيل الدخول
    }
  }
}
