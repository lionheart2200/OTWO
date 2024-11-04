import 'package:flutter/material.dart';
import 'package:otwo/Home.dart';
import 'package:otwo/widgets/QuizProvider%20.dart';
import 'package:otwo/widgets/consts.dart';
import 'package:provider/provider.dart';

class QuizQuestionsPage extends StatelessWidget {
  final String quizTitleId;
  final String quizTitle;
  final String stageId;
  final String classId;
  final String subjectId;
  final String userId;
  final String username;

  const QuizQuestionsPage({
    Key? key,
    required this.quizTitleId,
    required this.quizTitle,
    required this.stageId,
    required this.classId,
    required this.subjectId,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    // Load questions when the page is opened
    quizProvider.loadQuestions(stageId, classId, subjectId, quizTitleId);

    return Scaffold(
      // ... your existing code ...
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentQuestion =
              provider.questions[provider.currentQuestionIndex];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  currentQuestion['question'] ?? 'No question text',
                  style: myBarFont,
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: List.generate(4, (i) {
                    final isCorrectAnswer =
                        int.tryParse(currentQuestion['correctAnswer'] ?? '') ==
                            i;
                    final isSelected = provider.hasAnswered &&
                        (provider.currentQuestionIndex == i);
                    final color = provider.hasAnswered
                        ? (isCorrectAnswer
                            ? Colors.green
                            : (isSelected ? Colors.red : Colors.grey[200]))
                        : Colors.grey[200];

                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Card(
                        color: color,
                        child: ListTile(
                          title: Text(
                              '${i + 1}. ${currentQuestion['options'][i] ?? 'No option'}',
                              style: myDrobdownBlackFont),
                          onTap: () => provider.checkAnswer(i),
                        ),
                      ),
                    );
                  }),
                ),
                const Spacer(),
                ElevatedButton(
  onPressed: provider.hasAnswered
      ? () {
          provider.nextQuestion();
          if (provider.currentQuestionIndex ==
              provider.questions.length - 1) {
            _showScoreDialog(context, provider, username); // تمرير username هنا
          }
        }
      : null,
  child: Text(provider.currentQuestionIndex < provider.questions.length - 1
      ? 'السؤال التالي'
      : 'عرض النتيجة'),
),

              ],
            ),
          );
        },
      ),
    );
  }

  void _showScoreDialog(
      BuildContext context, QuizProvider provider, String username) {
    String message;
    if (provider.score == provider.questions.length) {
      message = '$username أنت البطل يا';
    } else if (provider.score >= provider.questions.length / 2) {
      message = '$username أداء جيد يا';
    } else {
      message = '$username إدرس جيدا يا';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('النتيجة',
              textAlign: TextAlign.center, style: myCardTitleFont),
          content: Text(
            'درجتك: ${provider.score}/${provider.questions.length}\n\n$message',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'jazera',
              fontWeight: FontWeight.bold,
              color: provider.score == provider.questions.length
                  ? Colors.blue
                  : provider.score >= provider.questions.length / 2
                      ? Colors.green
                      : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: const Text('الصفحة الرئيسية', style: myCardTitleFont),
              ),
            ),
          ],
        );
      },
    );
  }
}
