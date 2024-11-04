import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StageQuizProvider with ChangeNotifier {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId; // إضافة متغير userId
  String? username; // إضافة متغير username
  String? selectedStageId;
  String? selectedClassId;
  String? selectedSubjectId;
  List<QueryDocumentSnapshot>? quizList;
  Map<String, int> completedScores = {};

  StageQuizProvider() {
    _loadCompletedScores();
    _setUserDetails(); // تعيين تفاصيل المستخدم عند بدء المزود
  }

  Future<void> _loadCompletedScores() async {
    userId = _auth.currentUser?.uid; // تعيين userId
    if (userId != null) {
      final snapshot = await _firestore
          .collection('studentScores')
          .where('userId', isEqualTo: userId)
          .get();
      completedScores = {
        for (var doc in snapshot.docs) doc['quizTitleId']: doc['score']
      };
      notifyListeners();
    }
  }

  // وظيفة لتعيين تفاصيل المستخدم
  Future<void> _setUserDetails() async {
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        username = userDoc['displayName']; // تعيين username
        notifyListeners();
      }
    }
  }

  Future<List<DropdownMenuItem<String>>> getStages() async {
    List<DropdownMenuItem<String>> items = [];
    final snapshot = await _firestore.collection('quizStages').get();
    for (var doc in snapshot.docs) {
      items.add(DropdownMenuItem(
        value: doc.id,
        child: Text(doc['name']),
      ));
    }
    return items;
  }

  Future<List<DropdownMenuItem<String>>> getClasses() async {
    List<DropdownMenuItem<String>> items = [];
    if (selectedStageId != null) {
      final snapshot = await _firestore
          .collection('quizStages')
          .doc(selectedStageId)
          .collection('quizClasses')
          .get();
      for (var doc in snapshot.docs) {
        items.add(DropdownMenuItem(
          value: doc.id,
          child: Text(doc['name']),
        ));
      }
    }
    return items;
  }

  Future<List<DropdownMenuItem<String>>> getSubjects() async {
    List<DropdownMenuItem<String>> items = [];
    if (selectedClassId != null) {
      final snapshot = await _firestore
          .collection('quizStages')
          .doc(selectedStageId)
          .collection('quizClasses')
          .doc(selectedClassId)
          .collection('quizSubjects')
          .get();
      for (var doc in snapshot.docs) {
        items.add(DropdownMenuItem(
          value: doc.id,
          child: Text(doc['name']),
        ));
      }
    }
    return items;
  }

  Future<void> loadQuizzes() async {
    if (selectedSubjectId != null) {
      final snapshot = await _firestore
          .collection('quizStages')
          .doc(selectedStageId)
          .collection('quizClasses')
          .doc(selectedClassId)
          .collection('quizSubjects')
          .doc(selectedSubjectId)
          .collection('quizTitles')
          .get();
      quizList = snapshot.docs;
      notifyListeners();
    }
  }
}
