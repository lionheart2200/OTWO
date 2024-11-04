import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminStagesPage extends StatefulWidget {
  const AdminStagesPage({super.key});

  @override
  _AdminStagesPageState createState() => _AdminStagesPageState();
}

class _AdminStagesPageState extends State<AdminStagesPage> {
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadStage() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final imageUrl = await _uploadImageToStorage(_selectedImage!);
    await _firestore.collection('stages').add({
      'name': _nameController.text,
      'imageUrl': imageUrl,
    });

    _nameController.clear();
    setState(() => _selectedImage = null);
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('stages/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  void _deleteStage(String stageId) async {
    await _firestore.collection('stages').doc(stageId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stages')),
      body: Column(
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Stage Name')),
          ElevatedButton(onPressed: _pickImage, child: const Text('Select Image')),
          ElevatedButton(onPressed: _uploadStage, child: const Text('Add Stage')),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('stages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final stages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: stages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final stage = stages[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to AdminGradesPage with stage ID
                      },
                      child: Column(
                        children: [
                          Image.network(stage['imageUrl'], width: 80, height: 80),
                          Text(stage['name']),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteStage(stage.id),
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
