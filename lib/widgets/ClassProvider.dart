import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassProvider with ChangeNotifier {
  List<DocumentSnapshot> classes = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchClasses(String stageId) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('stageId', isEqualTo: stageId)
          .get();
      classes = snapshot.docs;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
