import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddQuestionsPage extends StatefulWidget {
  const AdminAddQuestionsPage({super.key});

  @override
  _AdminAddQuestionsPageState createState() => _AdminAddQuestionsPageState();
}

class _AdminAddQuestionsPageState extends State<AdminAddQuestionsPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  String? _correctAnswer;

  String? _selectedStageId;
  String? _selectedClassId;
  String? _selectedSubjectId;
  String? _selectedQuizId;

  // Load dropdown data from Firestore
  Future<List<DropdownMenuItem<String>>> _getStages() async {
    final stagesSnapshot =
        await FirebaseFirestore.instance.collection('quizStages').get();
    return stagesSnapshot.docs
        .map((doc) => DropdownMenuItem(
              value: doc.id,
              child: Text(doc['name']),
            ))
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _getClasses() async {
    if (_selectedStageId == null) return [];
    final classesSnapshot = await FirebaseFirestore.instance
        .collection('quizStages')
        .doc(_selectedStageId)
        .collection('quizClasses')
        .get();
    return classesSnapshot.docs
        .map((doc) => DropdownMenuItem(
              value: doc.id,
              child: Text(doc['name']),
            ))
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _getSubjects() async {
    if (_selectedClassId == null) return [];
    final subjectsSnapshot = await FirebaseFirestore.instance
        .collection('quizStages')
        .doc(_selectedStageId)
        .collection('quizClasses')
        .doc(_selectedClassId)
        .collection('quizSubjects')
        .get();
    return subjectsSnapshot.docs
        .map((doc) => DropdownMenuItem(
              value: doc.id,
              child: Text(doc['name']),
            ))
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _getQuizzes() async {
    if (_selectedSubjectId == null) return [];
    final quizzesSnapshot = await FirebaseFirestore.instance
        .collection('quizStages')
        .doc(_selectedStageId)
        .collection('quizClasses')
        .doc(_selectedClassId)
        .collection('quizSubjects')
        .doc(_selectedSubjectId)
        .collection('quizTitles')
        .get();
    return quizzesSnapshot.docs
        .map((doc) => DropdownMenuItem(
              value: doc.id,
              child: Text(doc['name']),
            ))
        .toList();
  }

  Future<void> _addQuestion() async {
    if (_formKey.currentState!.validate() &&
        _correctAnswer != null &&
        _selectedQuizId != null) {
      await FirebaseFirestore.instance
          .collection('quizStages')
          .doc(_selectedStageId)
          .collection('quizClasses')
          .doc(_selectedClassId)
          .collection('quizSubjects')
          .doc(_selectedSubjectId)
          .collection('quizTitles')
          .doc(_selectedQuizId)
          .collection('questions')
          .add({
        'question': _questionController.text,
        'options': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'correctAnswer': _correctAnswer,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة السؤال بنجاح')),
      );

      // Clear all controllers and reset state
      _questionController.clear();
      _option1Controller.clear();
      _option2Controller.clear();
      _option3Controller.clear();
      _option4Controller.clear();
      
      setState(() {
        _correctAnswer = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول وتحديد الإجابة الصحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة الأسئلة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FutureBuilder<List<DropdownMenuItem<String>>>(
                // Stages Dropdown
                future: _getStages(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedStageId,
                    hint: const Text('اختر المرحلة'),
                    items: snapshot.data!,
                    onChanged: (value) {
                      setState(() {
                        _selectedStageId = value;
                        _selectedClassId =
                            null; // Reset class and subject when stage changes
                        _selectedSubjectId = null;
                        _selectedQuizId = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار المرحلة' : null,
                  );
                },
              ),
              FutureBuilder<List<DropdownMenuItem<String>>>(
                // Classes Dropdown
                future: _getClasses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedClassId,
                    hint: const Text('اختر الصف'),
                    items: snapshot.data!,
                    onChanged: (value) {
                      setState(() {
                        _selectedClassId = value;
                        _selectedSubjectId =
                            null; // Reset subject and quiz when class changes
                        _selectedQuizId = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار الصف' : null,
                  );
                },
              ),
              FutureBuilder<List<DropdownMenuItem<String>>>(
                // Subjects Dropdown
                future: _getSubjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedSubjectId,
                    hint: const Text('اختر المادة'),
                    items: snapshot.data!,
                    onChanged: (value) {
                      setState(() {
                        _selectedSubjectId = value;
                        _selectedQuizId =
                            null; // Reset quiz when subject changes
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار المادة' : null,
                  );
                },
              ),
              FutureBuilder<List<DropdownMenuItem<String>>>(
                // Quizzes Dropdown
                future: _getQuizzes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedQuizId,
                    hint: const Text('اختر الاختبار'),
                    items: snapshot.data!,
                    onChanged: (value) {
                      setState(() {
                        _selectedQuizId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار الاختبار' : null,
                  );
                },
              ),
              TextFormField(
                // Question Input
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'السؤال'),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال السؤال'
                    : null,
              ),
              TextFormField(
                // Option 1 Input
                controller: _option1Controller,
                decoration: const InputDecoration(labelText: 'الخيار 1'),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال الخيار 1'
                    : null,
              ),
              TextFormField(
                // Option 2 Input
                controller: _option2Controller,
                decoration: const InputDecoration(labelText: 'الخيار 2'),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال الخيار 2'
                    : null,
              ),
              TextFormField(
                // Option 3 Input
                controller: _option3Controller,
                decoration: const InputDecoration(labelText: 'الخيار 3'),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال الخيار 3'
                    : null,
              ),
              TextFormField(
                // Option 4 Input
                controller: _option4Controller,
                decoration: const InputDecoration(labelText: 'الخيار 4'),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال الخيار 4'
                    : null,
              ),
              TextFormField(
                // Correct Answer Input
                decoration:
                    const InputDecoration(labelText: 'رقم الإجابة الصحيحة (1-4)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الاجابة';
                  }
                  final int? answer = int.tryParse(value);
                  if (answer == null || answer < 1 || answer > 4) {
                    return 'يجب أن يكون الرقم بين 1 و 4';
                  }
                  _correctAnswer = (answer-1).toString();
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addQuestion,
                child: const Text('إضافة السؤال'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
