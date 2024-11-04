import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoProvider with ChangeNotifier {
  List<DocumentSnapshot> videos = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchVideos(String stageId, String classId, String subjectId) async {
    isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stages')
          .doc(stageId)
          .collection('classes')
          .doc(classId)
          .collection('subjects')
          .doc(subjectId)
          .collection('videos')
          .get();

      videos = snapshot.docs;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
