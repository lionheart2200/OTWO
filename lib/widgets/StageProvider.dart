import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StageProvider with ChangeNotifier {
  List<DocumentSnapshot> stages = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchStages() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance.collection('stages').get();
      stages = snapshot.docs;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
