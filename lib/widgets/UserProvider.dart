import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userName;
  String _errorMessage = '';
  bool _isLoading = false;

  String? get userName => _userName;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data()?.containsKey('username') == true) {
        _userName = doc['username']; // Use 'username' to match your Firestore structure
        notifyListeners(); // Notify widgets that data has changed
      }
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    final query = await _firestore.collection('users').where('username', isEqualTo: username).get();
    return query.docs.isNotEmpty;
  }

  Future<void> registerUser(String username, String phone, String email, String password) async {
    _setLoading(true);

    try {
      // Check if username is already taken
      bool usernameExists = await isUsernameTaken(username);
      if (usernameExists) {
        _setError("اسم المستخدم محجوز بالفعل");
        return;
      }

      // Create user account with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update displayName in FirebaseAuth and save user data in Firestore
      await userCredential.user!.updateProfile(displayName: username);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'phone': phone,
        'email': email,
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Clear any error messages if successful
      _setError('');
      _userName = username; // Update the local userName
      notifyListeners(); // Notify listeners about the change
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _setError("البريد الإلكتروني مستخدم بالفعل");
      } else {
        _setError("خطأ في التسجيل: ${e.message}");
      }
    } catch (e) {
      _setError("خطأ في التسجيل: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
