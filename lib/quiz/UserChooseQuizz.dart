import 'package:flutter/material.dart';
import 'package:otwo/quiz/QuizQuestionsPage.dart';
import 'package:otwo/widgets/StageQuizProvider.dart';
import 'package:otwo/widgets/consts.dart';
import 'package:provider/provider.dart';

class UserChooseQuizz extends StatelessWidget {
  const UserChooseQuizz({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StageQuizProvider>(context);

    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: AppBar(
        backgroundColor: myBlackColor,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "الإختبارات",
              style: myBarFont,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stages Dropdown
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: provider.getStages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedStageId,
                    hint: const Text('اختر المرحلة', style: myDrobdownBlackFont),
                    items: snapshot.data,
                    onChanged: (value) {
                      provider.selectedStageId = value;
                      provider.selectedClassId = null;
                      provider.selectedSubjectId = null;
                      provider.quizList = null;
                      provider.notifyListeners();
                    },
                    dropdownColor: Colors.grey[200],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            // Classes Dropdown
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: provider.selectedStageId != null ? provider.getClasses() : null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedClassId,
                    hint: const Text('اختر الصف', style: myBottomBarFont),
                    items: snapshot.data,
                    onChanged: (value) {
                      provider.selectedClassId = value;
                      provider.selectedSubjectId = null;
                      provider.quizList = null;
                      provider.notifyListeners();
                    },
                    dropdownColor: Colors.grey[200],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            // Subjects Dropdown
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: provider.selectedClassId != null ? provider.getSubjects() : null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedSubjectId,
                    hint: const Text('اختر المادة', style: myBottomBarFont),
                    items: snapshot.data,
                    onChanged: (value) {
                      provider.selectedSubjectId = value;
                      provider.loadQuizzes();
                    },
                    dropdownColor: Colors.grey[200],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            // Quizzes List
            provider.quizList != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: provider.quizList!.length,
                      itemBuilder: (context, index) {
                        var quiz = provider.quizList![index];
                        return Card(
                          child: ListTile(
                            title: Text(quiz['title']),
                            trailing: provider.completedScores[quiz.id] != null
                                ? Text("Score: ${provider.completedScores[quiz.id]}") // Adjust this based on your data structure
                                : null,
                            onTap: () {
                              if (provider.selectedStageId != null && provider.selectedClassId != null && provider.selectedSubjectId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizQuestionsPage(
                                      quizTitleId: quiz.id,
                                      quizTitle: quiz['title'],
                                      stageId: provider.selectedStageId!,
                                      classId: provider.selectedClassId!,
                                      subjectId: provider.selectedSubjectId!,
                                      userId: provider.userId!,
                                      username: provider.username!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('يرجى اختيار المرحلة والصف والمادة أولاً.')),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text('لا توجد اختبارات متاحة')),
          ],
        ),
      ),
    );
  }
}
