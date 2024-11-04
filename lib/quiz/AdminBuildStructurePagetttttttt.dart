import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otwo/quiz/AdminAddQuestionsPagetttttttt.dart';

class AdminBuildStructurePage extends StatefulWidget {
  const AdminBuildStructurePage({super.key});

  @override
  _AdminBuildStructurePageState createState() => _AdminBuildStructurePageState();
}

class _AdminBuildStructurePageState extends State<AdminBuildStructurePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for different inputs
  final _stageController = TextEditingController();
  final _classController = TextEditingController();
  final _subjectController = TextEditingController();
  final _quizController = TextEditingController();

  String? selectedStage;
  String? selectedClass;
  String? selectedSubject;

  // Function to add educational stage
  Future<void> _addStage() async {
    if (_stageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizStages').add({
        'name': _stageController.text,
      });
      _stageController.clear();
      setState(() {});
    }
  }

  // Function to add class under a selected stage
  Future<void> _addClass() async {
    if (selectedStage != null && _classController.text.isNotEmpty) {
      final stageRef = FirebaseFirestore.instance.collection('quizStages').doc(selectedStage);
      await stageRef.collection('quizClasses').add({
        'name': _classController.text,
      });
      _classController.clear();
      setState(() {});
    }
  }

  // Function to add subject under a selected class
  Future<void> _addSubject() async {
    if (selectedStage != null && selectedClass != null && _subjectController.text.isNotEmpty) {
      final classRef = FirebaseFirestore.instance
          .collection('quizStages')
          .doc(selectedStage)
          .collection('quizClasses')
          .doc(selectedClass);
      await classRef.collection('quizSubjects').add({
        'name': _subjectController.text,
      });
      _subjectController.clear();
      setState(() {});
    }
  }

  // Function to add quiz title under a selected subject
  Future<void> _addQuiz() async {
    if (selectedStage != null && selectedClass != null && selectedSubject != null && _quizController.text.isNotEmpty) {
      final subjectRef = FirebaseFirestore.instance
          .collection('quizStages')
          .doc(selectedStage)
          .collection('quizClasses')
          .doc(selectedClass)
          .collection('quizSubjects')
          .doc(selectedSubject);
      await subjectRef.collection('quizTitles').add({
        'name': _quizController.text,
      });
      _quizController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة البنية التعليمية"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _stageController,
                  decoration: const InputDecoration(labelText: "اسم المرحلة"),
                ),
                ElevatedButton(
                  onPressed: _addStage,
                  child: const Text('إضافة المرحلة'),
                ),
                
                // Dropdown for Stages
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('quizStages').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    var stages = snapshot.data!.docs;
                    return DropdownButton<String>(
                      value: selectedStage,
                      hint: const Text("اختر المرحلة"),
                      items: stages.map<DropdownMenuItem<String>>((stage) {
                        return DropdownMenuItem<String>(
                          value: stage.id,
                          child: Text(stage['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStage = value;
                          selectedClass = null;
                          selectedSubject = null;
                        });
                      },
                    );
                  },
                ),
                
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: "اسم الصف"),
                ),
                ElevatedButton(
                  onPressed: _addClass,
                  child: const Text('إضافة الصف'),
                ),
            
                // Dropdown for Classes
                if (selectedStage != null)
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('quizStages')
                        .doc(selectedStage)
                        .collection('quizClasses')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      var classes = snapshot.data!.docs;
                      return DropdownButton<String>(
                        value: selectedClass,
                        hint: const Text("اختر الصف"),
                        items: classes.map<DropdownMenuItem<String>>((classDoc) {
                          return DropdownMenuItem<String>(
                            value: classDoc.id,
                            child: Text(classDoc['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                            selectedSubject = null;
                          });
                        },
                      );
                    },
                  ),
            
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: "اسم المادة"),
                ),
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text('إضافة المادة'),
                ),
            
                // Dropdown for Subjects
                if (selectedClass != null)
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('quizStages')
                        .doc(selectedStage)
                        .collection('quizClasses')
                        .doc(selectedClass)
                        .collection('quizSubjects')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      var subjects = snapshot.data!.docs;
                      return DropdownButton<String>(
                        value: selectedSubject,
                        hint: const Text("اختر المادة"),
                        items: subjects.map<DropdownMenuItem<String>>((subject) {
                          return DropdownMenuItem<String>(
                            value: subject.id,
                            child: Text(subject['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value;
                          });
                        },
                      );
                    },
                  ),
            
                TextFormField(
                  controller: _quizController,
                  decoration: const InputDecoration(labelText: "اسم الاختبار"),
                ),
                ElevatedButton(
                  onPressed: _addQuiz,
                  child: const Text('إضافة الاختبار'),
                ),
            
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminAddQuestionsPage()),
                    );
                  },
                  child: const Text('الانتقال إلى شاشة إضافة الأسئلة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






// Separate page for adding questions














