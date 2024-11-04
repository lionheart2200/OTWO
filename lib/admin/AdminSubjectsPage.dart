import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminSubjectsPage extends StatefulWidget {
  const AdminSubjectsPage({super.key});

  @override
  _AdminSubjectsPageState createState() => _AdminSubjectsPageState();
}

class _AdminSubjectsPageState extends State<AdminSubjectsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _subjectNameController = TextEditingController();
  File? _selectedImage;
  String? _selectedStageId;
  String? _selectedClassId;

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('subjects/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Add a new subject to Firestore
  Future<void> _addSubject() async {
    if (_subjectNameController.text.isEmpty || _selectedImage == null || _selectedStageId == null || _selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter subject name, select an image, and choose a stage and class.')),
      );
      return;
    }

    final imageUrl = await _uploadImage(_selectedImage!);

    await _firestore.collection('subjects').add({
      'name': _subjectNameController.text,
      'imageUrl': imageUrl,
      'stageId': _selectedStageId,
      'classId': _selectedClassId,
    });

    _subjectNameController.clear();
    setState(() => _selectedImage = null);
  }

  // Edit an existing subject's name
  Future<void> _editSubjectName(String subjectId, String currentName) async {
    final editController = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Subject Name'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Subject Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _firestore.collection('subjects').doc(subjectId).update({
                  'name': editController.text,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete a subject
  void _deleteSubject(String subjectId) async {
    await _firestore.collection('subjects').doc(subjectId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Subjects')),
      body: Column(
        children: [
          // Dropdown for selecting Stage
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('stages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final stages = snapshot.data!.docs;
              return DropdownButton<String>(
                hint: const Text('Select Stage'),
                value: _selectedStageId,
                onChanged: (value) {
                  setState(() {
                    _selectedStageId = value;
                    _selectedClassId = null; // Reset class selection when stage changes
                  });
                },
                items: stages.map((stage) {
                  return DropdownMenuItem(
                    value: stage.id,
                    child: Text(stage['name']),
                  );
                }).toList(),
              );
            },
          ),

          // Dropdown for selecting Class (filtered by selected stage)
          if (_selectedStageId != null)
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('classes')
                .where('stageId', isEqualTo: _selectedStageId)
                .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final classes = snapshot.data!.docs;
                return DropdownButton<String>(
                  hint: const Text('Select Class'),
                  value: _selectedClassId,
                  onChanged: (value) {
                    setState(() {
                      _selectedClassId = value;
                    });
                  },
                  items: classes.map((classData) {
                    return DropdownMenuItem(
                      value: classData.id,
                      child: Text(classData['name']),
                    );
                  }).toList(),
                );
              },
            ),

          // Input for Subject Name and Image selection
          TextField(
            controller: _subjectNameController,
            decoration: const InputDecoration(labelText: 'Subject Name'),
          ),
          ElevatedButton(onPressed: _pickImage, child: const Text('Select Image')),
          ElevatedButton(onPressed: _addSubject, child: const Text('Add Subject')),

          // Display subjects for selected class
          if (_selectedClassId != null)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('subjects')
                    .where('classId', isEqualTo: _selectedClassId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final subjects = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subjectData = subjects[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  subjectData['imageUrl'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                subjectData['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSubjectName(
                                    subjectData.id,
                                    subjectData['name'],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteSubject(subjectData.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
