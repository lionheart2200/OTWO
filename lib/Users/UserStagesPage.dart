import 'package:flutter/material.dart';
import 'package:otwo/widgets/StageProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otwo/widgets/DisplayCarouselWidget.dart';
import 'package:otwo/widgets/consts.dart';
import 'UserClassesPage.dart';

class UserStagesPage extends StatefulWidget {
  final String? userId; // User ID

  const UserStagesPage({super.key, this.userId}); // Pass userId here

  @override
  _UserStagesPageState createState() => _UserStagesPageState();
}

class _UserStagesPageState extends State<UserStagesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch stages when the page is initialized
    Future.microtask(() {
      final stageProvider = Provider.of<StageProvider>(context, listen: false);
      stageProvider.fetchStages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stageProvider = Provider.of<StageProvider>(context);

    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: AppBar(
        backgroundColor: myBlackColor,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("المراحل الدراسية", style: myBarFont),
          ),
        ],
      ),
      body: Column(
        children: [
           DisplayCarouselWidget(),
          Expanded(
            child: stageProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : stageProvider.stages.isEmpty
                    ? const Center(child: Text('No stages available'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in each row
                          crossAxisSpacing: 10, // Horizontal spacing between columns
                          mainAxisSpacing: 10, // Vertical spacing between rows
                          childAspectRatio: 0.8, // Aspect ratio for the cards
                        ),
                        itemCount: stageProvider.stages.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final stage = stageProvider.stages[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserClassesPage(
                                    stageId: stage.id,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        stage['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      stage['name'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'jazera',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
