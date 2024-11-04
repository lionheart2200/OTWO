import 'package:flutter/material.dart';
import 'package:otwo/widgets/ClassProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otwo/Users/UserSubjectsPage.dart';

class UserClassesPage extends StatefulWidget {
  final String stageId;
  final String? userId;

  UserClassesPage({super.key, required this.stageId, this.userId});

  @override
  _UserClassesPageState createState() => _UserClassesPageState();
}

class _UserClassesPageState extends State<UserClassesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch classes when the page is initialized
    Future.microtask(() {
      final classProvider = Provider.of<ClassProvider>(context, listen: false);
      classProvider.fetchClasses(widget.stageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Use Navigator.popUntil to return to the previous page correctly
        Navigator.popUntil(context, (route) => route.settings.name != '/login');
        return false; // Return false to prevent the default closing behavior
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Available Classes')),
        body: classProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : classProvider.classes.isEmpty
                ? const Center(child: Text('No classes available for this stage'))
                : ListView.builder(
                    itemCount: classProvider.classes.length,
                    itemBuilder: (context, index) {
                      final classData = classProvider.classes[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSubjectsPage(
                                classId: classData.id,
                                stageId: widget.stageId,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Image.network(
                              classData['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(classData['name']),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
