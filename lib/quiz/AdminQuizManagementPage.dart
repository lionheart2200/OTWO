import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQuizManagementPage extends StatefulWidget {
  final String? userId; // تمرير userId

  const AdminQuizManagementPage({super.key, this.userId}); // إضافة userId كمعامل اختياري

  @override
  _AdminQuizManagementPageState createState() => _AdminQuizManagementPageState();
}

class _AdminQuizManagementPageState extends State<AdminQuizManagementPage> {
  final TextEditingController _stageController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _quizTitleController = TextEditingController();

  String? selectedStageId;
  String? selectedClassId;
  String? selectedSubjectId;
  String? selectedQuizTitleId;

  // Functions for adding new entries
  Future<void> _addQuizStage() async {
    if (_stageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages').add({
        'name': _stageController.text,
      });
      _stageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Stage added successfully!')));
    }
  }

  Future<void> _addQuizClass() async {
    if (selectedStageId != null && _classController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages')
          .doc(selectedStageId)
          .collection('quizclasses')
          .add({'name': _classController.text});
      _classController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Class added successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a stage and enter a class name.')));
    }
  }

  Future<void> _addQuizSubject() async {
    if (selectedStageId != null && selectedClassId != null && _subjectController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages')
          .doc(selectedStageId)
          .collection('quizclasses')
          .doc(selectedClassId)
          .collection('quizsubjects')
          .add({'name': _subjectController.text});
      _subjectController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Subject added successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a stage, a class, and enter a subject name.')));
    }
  }

// تعديل دالة _addQuizTitle لتشمل userId
  Future<void> _addQuizTitle() async {
    if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null && _quizTitleController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('quizstages')
          .doc(selectedStageId)
          .collection('quizclasses')
          .doc(selectedClassId)
          .collection('quizsubjects')
          .doc(selectedSubjectId)
          .collection('quiztitles')
          .add({
        'title': _quizTitleController.text,
        'userId': widget.userId, // إضافة userId إلى البيانات
      });
      _quizTitleController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Title added successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a stage, class, and subject, and enter a quiz title.')));
    }
  }


  // Function to delete a selected quiz stage
  Future<void> _deleteQuizStage(String stageId) async {
    await FirebaseFirestore.instance.collection('quizstages').doc(stageId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Stage deleted successfully!')));
  }

  // Function to delete a selected quiz class
  Future<void> _deleteQuizClass(String stageId, String classId) async {
    await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Class deleted successfully!')));
  }

  // Function to delete a selected quiz subject
  Future<void> _deleteQuizSubject(String stageId, String classId, String subjectId) async {
    await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).collection('quizsubjects').doc(subjectId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Subject deleted successfully!')));
  }

  // Function to delete a selected quiz title
  Future<void> _deleteQuizTitle(String stageId, String classId, String subjectId, String titleId) async {
    await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).collection('quizsubjects').doc(subjectId).collection('quiztitles').doc(titleId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Title deleted successfully!')));
  }

  // Function to update a quiz stage name
  Future<void> _updateQuizStage(String stageId) async {
    if (_stageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages').doc(stageId).update({
        'name': _stageController.text,
      });
      _stageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Stage updated successfully!')));
    }
  }

  // Function to update a quiz class name
  Future<void> _updateQuizClass(String stageId, String classId) async {
    if (_classController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).update({
        'name': _classController.text,
      });
      _classController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Class updated successfully!')));
    }
  }

  // Function to update a quiz subject name
  Future<void> _updateQuizSubject(String stageId, String classId, String subjectId) async {
    if (_subjectController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).collection('quizsubjects').doc(subjectId).update({
        'name': _subjectController.text,
      });
      _subjectController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Subject updated successfully!')));
    }
  }

  // Function to update a quiz title name
  Future<void> _updateQuizTitle(String stageId, String classId, String subjectId, String titleId) async {
    if (_quizTitleController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('quizstages').doc(stageId).collection('quizclasses').doc(classId).collection('quizsubjects').doc(subjectId).collection('quiztitles').doc(titleId).update({
        'title': _quizTitleController.text,
      });
      _quizTitleController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz Title updated successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Quiz Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section for adding Quiz Stage
              const Text("Add Quiz Stage", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _stageController,
                decoration: const InputDecoration(labelText: 'Quiz Stage Name'),
              ),
              ElevatedButton(onPressed: _addQuizStage, child: const Text("Add Quiz Stage")),
              const SizedBox(height: 20),

              // Section for adding Quiz Class
              const Text("Add Quiz Class to a Stage", style: TextStyle(fontWeight: FontWeight.bold)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('quizstages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField(
                    hint: const Text('Select Quiz Stage'),
                    value: selectedStageId,
                    items: snapshot.data!.docs.map((doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStageId = value;
                        selectedClassId = null;
                        selectedSubjectId = null;
                        selectedQuizTitleId = null; // Reset Quiz Title selection
                      });
                    },
                  );
                },
              ),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Quiz Class Name'),
              ),
              ElevatedButton(onPressed: _addQuizClass, child: const Text("Add Quiz Class")),
              const SizedBox(height: 20),

              // Section for adding Quiz Subject
              if (selectedStageId != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Add Quiz Subject to a Class", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').doc(selectedStageId).collection('quizclasses').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Class'),
                          value: selectedClassId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClassId = value;
                              selectedSubjectId = null;
                              selectedQuizTitleId = null; // Reset Quiz Title selection
                            });
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(labelText: 'Quiz Subject Name'),
                    ),
                    ElevatedButton(onPressed: _addQuizSubject, child: const Text("Add Quiz Subject")),
                    const SizedBox(height: 20),

                    // Section for adding Quiz Title
                    const Text("Add Quiz Title to a Subject", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').doc(selectedStageId).collection('quizclasses').doc(selectedClassId).collection('quizsubjects').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Subject'),
                          value: selectedSubjectId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubjectId = value;
                            });
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: _quizTitleController,
                      decoration: const InputDecoration(labelText: 'Quiz Title Name'),
                    ),
                    ElevatedButton(onPressed: _addQuizTitle, child: const Text("Add Quiz Title")),
                    const SizedBox(height: 20),

                    // View Quiz Titles
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     // builder: (context) => QuizTitlesPage(
                          //     //    quizId: 'معرف الاختبار', // استبدل هذا بالقيمة المناسبة
                          //     //    stageId: selectedStageId!, // معرف المرحلة المحددة
                          //     //    classId: selectedClassId!, // معرف الصف المحدد
                          //     //    subjectId: selectedSubjectId!, // معرف المادة المحددة
                          //     //    titleId: 'معرف العنوان', // استبدل هذا بالقيمة المناسبة
                          //     //    userId: 'معرف المستخدم', // استبدل هذا بالقيمة المناسبة
                          //     //    userName: 'اسم المستخدم', // استبدل هذا بالقيمة المناسبة
                          //     //    onQuizComplete: (int score) {
                          //     //      // إضافة ما تريد أن يحدث عند إكمال الاختبار
                          //     //       },
                          //     // ),
                          //   ),
                          // );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a stage, class, and subject')),
                          );
                        }
                      },
                      child: const Text("View Quiz Titles"),
                    ),
                    const SizedBox(height: 20),

                    // Deleting and Updating Quiz Stage
                    const Text("Manage Quiz Stage", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Stage to Delete/Update'),
                          value: selectedStageId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStageId = value;
                              _stageController.text = snapshot.data!.docs.firstWhere((doc) => doc.id == selectedStageId!)['name'];
                            });
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null) {
                          _updateQuizStage(selectedStageId!);
                        }
                      },
                      child: const Text("Update Selected Quiz Stage"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null) {
                          _deleteQuizStage(selectedStageId!);
                        }
                      },
                      child: const Text("Delete Selected Quiz Stage"),
                    ),
                    const SizedBox(height: 20),

                    // Deleting and Updating Quiz Class
                    const Text("Manage Quiz Class", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').doc(selectedStageId).collection('quizclasses').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Class to Delete/Update'),
                          value: selectedClassId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClassId = value;
                              _classController.text = snapshot.data!.docs.firstWhere((doc) => doc.id == selectedClassId!)['name'];
                            });
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null) {
                          _updateQuizClass(selectedStageId!, selectedClassId!);
                        }
                      },
                      child: const Text("Update Selected Quiz Class"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null) {
                          _deleteQuizClass(selectedStageId!, selectedClassId!);
                        }
                      },
                      child: const Text("Delete Selected Quiz Class"),
                    ),
                    const SizedBox(height: 20),

                    // Deleting and Updating Quiz Subject
                    const Text("Manage Quiz Subject", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').doc(selectedStageId).collection('quizclasses').doc(selectedClassId).collection('quizsubjects').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Subject to Delete/Update'),
                          value: selectedSubjectId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubjectId = value;
                              _subjectController.text = snapshot.data!.docs.firstWhere((doc) => doc.id == selectedSubjectId!)['name'];
                            });
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null) {
                          _updateQuizSubject(selectedStageId!, selectedClassId!, selectedSubjectId!);
                        }
                      },
                      child: const Text("Update Selected Quiz Subject"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null) {
                          _deleteQuizSubject(selectedStageId!, selectedClassId!, selectedSubjectId!);
                        }
                      },
                      child: const Text("Delete Selected Quiz Subject"),
                    ),
                    const SizedBox(height: 20),

                    // Deleting and Updating Quiz Title
                    const Text("Manage Quiz Title", style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('quizstages').doc(selectedStageId).collection('quizclasses').doc(selectedClassId).collection('quizsubjects').doc(selectedSubjectId).collection('quiztitles').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField(
                          hint: const Text('Select Quiz Title to Delete/Update'),
                          value: selectedQuizTitleId,
                          items: snapshot.data!.docs.map((doc) {
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(doc['title']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedQuizTitleId = value;
                              _quizTitleController.text = snapshot.data!.docs.firstWhere((doc) => doc.id == selectedQuizTitleId!)['title'];
                            });
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null && selectedQuizTitleId != null) {
                          _updateQuizTitle(selectedStageId!, selectedClassId!, selectedSubjectId!, selectedQuizTitleId!);
                        }
                      },
                      child: const Text("Update Selected Quiz Title"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedStageId != null && selectedClassId != null && selectedSubjectId != null && selectedQuizTitleId != null) {
                          _deleteQuizTitle(selectedStageId!, selectedClassId!, selectedSubjectId!, selectedQuizTitleId!);
                        }
                      },
                      child: const Text("Delete Selected Quiz Title"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
