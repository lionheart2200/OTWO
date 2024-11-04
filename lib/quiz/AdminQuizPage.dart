import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQuizPage extends StatefulWidget {
  const AdminQuizPage({super.key});

  @override
  _AdminQuizPageState createState() => _AdminQuizPageState();
}

class _AdminQuizPageState extends State<AdminQuizPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedQuizTitleId; // معرف عنوان الاختبار المختار
  String question = '';
  List<String> options = ['', '', '', ''];
  String correctAnswer = '';
  String? quizStageId;
  String? quizClassId;
  String? quizSubjectId;

  Future<void> _addQuestion() async {
    if (_formKey.currentState!.validate() && quizStageId != null && quizClassId != null && quizSubjectId != null && selectedQuizTitleId != null) {
      await FirebaseFirestore.instance
          .collection('quizstages')
          .doc(quizStageId)
          .collection('quizclasses')
          .doc(quizClassId)
          .collection('quizsubjects')
          .doc(quizSubjectId)
          .collection('quiztitles')
          .doc(selectedQuizTitleId) // ربط السؤال بعنوان الاختبار المختار
          .collection('questions')
          .add({
        'question': question,
        'options': options,
        'answer': correctAnswer,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Question added successfully!')));
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select all required fields.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Add Quiz Question")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // اختيار Quiz Stage
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('quizstages').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return DropdownButtonFormField(
                      hint: const Text('Select Quiz Stage'),
                      value: quizStageId,
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          quizStageId = value;
                          quizClassId = null;
                          quizSubjectId = null;
                          selectedQuizTitleId = null;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a quiz stage' : null,
                    );
                  },
                ),
                
                // اختيار Quiz Class بناءً على Quiz Stage
                if (quizStageId != null)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('quizstages').doc(quizStageId).collection('quizclasses').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return DropdownButtonFormField(
                        hint: const Text('Select Quiz Class'),
                        value: quizClassId,
                        items: snapshot.data!.docs.map((doc) {
                          return DropdownMenuItem(
                            value: doc.id,
                            child: Text(doc['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            quizClassId = value;
                            quizSubjectId = null;
                            selectedQuizTitleId = null;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a quiz class' : null,
                      );
                    },
                  ),
                  
                // اختيار Quiz Subject بناءً على Quiz Class
                if (quizClassId != null)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('quizstages')
                        .doc(quizStageId)
                        .collection('quizclasses')
                        .doc(quizClassId)
                        .collection('quizsubjects')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return DropdownButtonFormField(
                        hint: const Text('Select Quiz Subject'),
                        value: quizSubjectId,
                        items: snapshot.data!.docs.map((doc) {
                          return DropdownMenuItem(
                            value: doc.id,
                            child: Text(doc['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            quizSubjectId = value;
                            selectedQuizTitleId = null;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a quiz subject' : null,
                      );
                    },
                  ),
                  
                // اختيار Quiz Title بناءً على Quiz Subject
                if (quizSubjectId != null)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('quizstages')
                        .doc(quizStageId)
                        .collection('quizclasses')
                        .doc(quizClassId)
                        .collection('quizsubjects')
                        .doc(quizSubjectId)
                        .collection('quiztitles')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return DropdownButtonFormField(
                        hint: const Text('Select Quiz Title'),
                        value: selectedQuizTitleId,
                        items: snapshot.data!.docs.map((doc) {
                          return DropdownMenuItem(
                            value: doc.id,
                            child: Text(doc['title']), // assuming each quiz doc has a 'title' field
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedQuizTitleId = value;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a quiz title' : null,
                      );
                    },
                  ),
                
                // إدخال السؤال واختياراته
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Question'),
                  onChanged: (value) => question = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
                ),
                ...List.generate(4, (index) {
                  return TextFormField(
                    decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                    onChanged: (value) => options[index] = value,
                    validator: (value) => value!.isEmpty ? 'Please enter an option' : null,
                  );
                }),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Correct Answer'),
                  onChanged: (value) => correctAnswer = value,
                  validator: (value) => value!.isEmpty ? 'Please enter the correct answer' : null,
                ),
                
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: const Text("Add Question"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
