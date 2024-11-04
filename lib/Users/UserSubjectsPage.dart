import 'package:flutter/material.dart';
import 'package:otwo/widgets/SubjectProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserVideosPage.dart';

class UserSubjectsPage extends StatefulWidget {
  final String classId; // Class ID
  final String stageId; // Stage ID
  final String? userId; // Optional userId

  const UserSubjectsPage({
    super.key,
    required this.classId,
    required this.stageId,
    this.userId,
  });

  @override
  _UserSubjectsPageState createState() => _UserSubjectsPageState();
}

class _UserSubjectsPageState extends State<UserSubjectsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch subjects when the page is initialized
    Future.microtask(() {
      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
      subjectProvider.fetchSubjects(widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: subjectProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : subjectProvider.subjects.isEmpty
              ? const Center(child: Text('No subjects available for this class'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: subjectProvider.subjects.length,
                  itemBuilder: (context, index) {
                    final subjectData = subjectProvider.subjects[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserVideosPage(
                              subjectId: subjectData.id,
                              classId: widget.classId,
                              stageId: widget.stageId,
                              userId: widget.userId, // Pass userId here
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
