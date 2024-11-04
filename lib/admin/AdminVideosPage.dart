import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminVideosPage extends StatefulWidget {
  const AdminVideosPage({super.key});

  @override
  _AdminVideosPageState createState() => _AdminVideosPageState();
}

class _AdminVideosPageState extends State<AdminVideosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _videoNameController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  File? _selectedImage;
  String? _selectedStageId;
  String? _selectedClassId;
  String? _selectedSubjectId;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('videos/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> _addVideo() async {
    if (_videoNameController.text.isEmpty ||
        _videoUrlController.text.isEmpty ||
        _selectedImage == null ||
        _selectedStageId == null ||
        _selectedClassId == null ||
        _selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final imageUrl = await _uploadImage(_selectedImage!);

      await _firestore
          .collection('stages')
          .doc(_selectedStageId)
          .collection('classes')
          .doc(_selectedClassId)
          .collection('subjects')
          .doc(_selectedSubjectId)
          .collection('videos')
          .add({
        'name': _videoNameController.text,
        'videoUrl': _videoUrlController.text,
        'imageUrl': imageUrl,
      });

      _videoNameController.clear();
      _videoUrlController.clear();
      setState(() {
        _selectedImage = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video added successfully!')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload video. Please try again.')),
      );
    }
  }

  Future<void> _deleteVideo(String videoId) async {
    try {
      await _firestore
          .collection('stages')
          .doc(_selectedStageId)
          .collection('classes')
          .doc(_selectedClassId)
          .collection('subjects')
          .doc(_selectedSubjectId)
          .collection('videos')
          .doc(videoId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete video')),
      );
    }
  }

  void _editVideo(DocumentSnapshot video) {
    _videoNameController.text = video['name'];
    _videoUrlController.text = video['videoUrl'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Video"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _videoNameController,
                decoration: const InputDecoration(labelText: 'Video Name'),
              ),
              TextField(
                controller: _videoUrlController,
                decoration: const InputDecoration(labelText: 'Video URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateVideo(video.id);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateVideo(String videoId) async {
    try {
      await _firestore
          .collection('stages')
          .doc(_selectedStageId)
          .collection('classes')
          .doc(_selectedClassId)
          .collection('subjects')
          .doc(_selectedSubjectId)
          .collection('videos')
          .doc(videoId)
          .update({
        'name': _videoNameController.text,
        'videoUrl': _videoUrlController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Videos')),
      body: Column(
        children: [
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
                    _selectedClassId = null;
                    _selectedSubjectId = null;
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
          if (_selectedStageId != null)
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('classes')
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
                      _selectedSubjectId = null;
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
          if (_selectedClassId != null)
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('subjects')
                  .where('classId', isEqualTo: _selectedClassId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final subjects = snapshot.data!.docs;
                return DropdownButton<String>(
                  hint: const Text('Select Subject'),
                  value: _selectedSubjectId,
                  onChanged: (value) {
                    setState(() => _selectedSubjectId = value);
                  },
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject.id,
                      child: Text(subject['name']),
                    );
                  }).toList(),
                );
              },
            ),
          TextField(
            controller: _videoNameController,
            decoration: const InputDecoration(labelText: 'Video Name'),
          ),
          TextField(
            controller: _videoUrlController,
            decoration: const InputDecoration(labelText: 'Video URL'),
          ),
          ElevatedButton(onPressed: _pickImage, child: const Text('Select Image')),
          _isUploading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _addVideo, child: const Text('Add Video')),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('stages')
                  .doc(_selectedStageId)
                  .collection('classes')
                  .doc(_selectedClassId)
                  .collection('subjects')
                  .doc(_selectedSubjectId)
                  .collection('videos')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final videos = snapshot.data!.docs;
                if (videos.isEmpty) {
                  return const Center(child: Text("No videos available"));
                }

                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Card(
                      child: ListTile(
                        title: Text(video['name']),
                        subtitle: Text(video['videoUrl']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editVideo(video),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteVideo(video.id),
                            ),
                          ],
                        ),
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
