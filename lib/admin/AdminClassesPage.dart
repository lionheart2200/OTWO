import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminClassesPage extends StatefulWidget {
  const AdminClassesPage({super.key});

  @override
  _AdminClassesPageState createState() => _AdminClassesPageState();
}

class _AdminClassesPageState extends State<AdminClassesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  String? _selectedStage; // For storing selected stage ID
  final _stages = []; // To hold available stages

  @override
  void initState() {
    super.initState();
    _fetchStages(); // Fetch stages from Firebase on initialization
  }

  // Fetch available stages
  Future<void> _fetchStages() async {
    final stagesSnapshot = await _firestore.collection('stages').get();
    setState(() {
      _stages.addAll(stagesSnapshot.docs);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadClass() async {
    if (_nameController.text.isEmpty || _selectedImage == null || _selectedStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a stage.')),
      );
      return;
    }

    final imageUrl = await _uploadImageToStorage(_selectedImage!);
    await _firestore.collection('classes').add({
      'name': _nameController.text,
      'imageUrl': imageUrl,
      'stageId': _selectedStage, // Associate class with a stage
    });

    _nameController.clear();
    setState(() => _selectedImage = null);
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('classes/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  void _deleteClass(String classId) async {
    await _firestore.collection('classes').doc(classId).delete();
  }

  // Function to update class name
  Future<void> _editClassName(String classId, String currentName) async {
    final TextEditingController editController = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Class Name'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Class Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _firestore.collection('classes').doc(classId).update({'name': editController.text});
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Classes')),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Class Name'),
          ),
          DropdownButton<String>(
            hint: const Text('Select Stage'),
            value: _selectedStage,
            onChanged: (String? newValue) {
              setState(() => _selectedStage = newValue);
            },
            items: _stages.map((stage) {
              return DropdownMenuItem<String>(
                value: stage.id,
                child: Text(stage['name']),
              );
            }).toList(),
          ),
          ElevatedButton(onPressed: _pickImage, child: const Text('Select Image')),
          ElevatedButton(onPressed: _uploadClass, child: const Text('Add Class')),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('classes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final classes = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classData = classes[index];
                    return ListTile(
  leading: Image.network(classData['imageUrl']),
  title: Text(classData['name']),
  subtitle: Text(
  'Stage ID: ${(classData.data() as Map<String, dynamic>).containsKey('stageId') ? classData['stageId'] : 'No stage assigned'}',
),

  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editClassName(classData.id, classData['name']),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _deleteClass(classData.id),
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
