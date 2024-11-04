import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizProvider with ChangeNotifier {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;

    String username; // Add this line

     QuizProvider(this.username); // Add this line to the constructor


  List<Map<String, dynamic>> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get hasAnswered => _hasAnswered;

  void loadQuestions(String stageId, String classId, String subjectId, String quizTitleId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizStages')
        .doc(stageId)
        .collection('quizClasses')
        .doc(classId)
        .collection('quizSubjects')
        .doc(subjectId)
        .collection('quizTitles')
        .doc(quizTitleId)
        .collection('questions')
        .get();

    _questions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    notifyListeners();
  }

  void checkAnswer(int selectedAnswerIndex) {
    if (_hasAnswered) return;

    _hasAnswered = true;
    if (int.tryParse(_questions[_currentQuestionIndex]['correctAnswer'] ?? '') == selectedAnswerIndex) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _hasAnswered = false;
      notifyListeners();
    }
  }

  void reset() {
    _currentQuestionIndex = 0;
    _score = 0;
    _hasAnswered = false;
    notifyListeners();
  }
}
