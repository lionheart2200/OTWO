import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _phoneNumber;
  String? _email;
  int? _score;
  int? _rank;

  String? get username => _username;
  String? get phoneNumber => _phoneNumber;
  String? get email => _email;
  int? get score => _score;
  int? get rank => _rank;

  UserProfileProvider() {
    _loadUserProfile();
    _loadUserRank();
  }

  Future<void> _loadUserProfile() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _username = doc['username'];
        _phoneNumber = doc['phone'];
        _email = doc['email'];
        _score = doc['score'];
        notifyListeners();
      }
    }
  }

  Future<void> _loadUserRank() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore.collection('studentScores')
          .orderBy('score', descending: true).get();
      for (int i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i].id == userId) {
          _rank = i + 1;
          notifyListeners();
          break;
        }
      }
    }
  }

  Future<void> updateProfile(String? newUsername, String? newPhoneNumber) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'username': newUsername ?? _username,
        'phone': newPhoneNumber ?? _phoneNumber,
      });
      _username = newUsername;
      _phoneNumber = newPhoneNumber;
      notifyListeners();
    }
  }
}
