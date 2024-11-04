import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminPageAds extends StatefulWidget {
  const AdminPageAds({super.key});

  @override
  _AdminPageAdsState createState() => _AdminPageAdsState();
}

class _AdminPageAdsState extends State<AdminPageAds> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        TaskSnapshot snapshot = await _storage
            .ref('carousel_images/$fileName')
            .putFile(imageFile);

        // Get the image URL from Firebase Storage
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Save image URL to Firestore with the Storage path to delete later
        await _firestore.collection('carousel_images').add({
          'url': imageUrl,
          'storagePath': snapshot.ref.fullPath,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!'))
        );
      } catch (e) {
        print("Error uploading image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image'))
        );
      }
    }
  }

  Future<void> _deleteImage(DocumentSnapshot doc) async {
    try {
      // Delete from Firebase Storage
      await _storage.ref(doc['storagePath']).delete();
      // Delete from Firestore
      await _firestore.collection('carousel_images').doc(doc.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted successfully'))
      );
    } catch (e) {
      print("Error deleting image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete image'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Page - Manage Carousel Images")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text("Upload Image"),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('carousel_images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No images available"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      leading: Image.network(doc['url'], width: 50, height: 50),
                      title: const Text("Image"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteImage(doc),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
