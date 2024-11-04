import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectProvider with ChangeNotifier {
  List<DocumentSnapshot> subjects = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchSubjects(String classId) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .where('classId', isEqualTo: classId)
          .get();

      subjects = snapshot.docs;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
