import 'package:flutter/material.dart';
import 'package:otwo/quiz/AdminAddQuestionsPagetttttttt.dart';
import 'package:otwo/quiz/AdminBuildStructurePagetttttttt.dart';
import 'package:otwo/widgets/UserProvider.dart';
import 'package:provider/provider.dart';
import 'Users/UserStagesPage.dart';
import 'quiz/AllUsersScoresPage.dart';
import 'auth/UserProfilePage.dart';
import 'admin/AdminPageAds.dart';
import 'Home.dart';
import 'quiz/UserChooseQuizz.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 35, 61, 193),
              Color.fromARGB(255, 221, 48, 252),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: [0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            if (userName != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, $userName!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            _buildNavigationButton(context, UserStagesPage(), "Stages"),
            _buildNavigationButton(context, AdminBuildStructurePage(), "Add Stage, Class..."),
            _buildNavigationButton(context, AdminAddQuestionsPage(), "Add Question"),
            _buildNavigationButton(context, UserChooseQuizz(), "User Choose Quiz"),
            _buildNavigationButton(context, AllUsersScoresPage(), "All Scores"),
            _buildNavigationButton(context, UserProfilePage(), "Profile"),
            _buildNavigationButton(context, Home(), "Home"),
            _buildNavigationButton(context, AdminPageAds(), "Ads"),
            _buildGradientButton('Button with Gradient', Colors.blue, Colors.purple),
            const SizedBox(height: 20),
            _buildGradientButton('Button with Gradient', Colors.black, Colors.green, customFont: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, Widget page, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(label),
    );
  }

  Widget _buildGradientButton(String label, Color color1, Color color2, {bool customFont = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: customFont ? 'jazera' : null,
          fontWeight: customFont ? FontWeight.w800 : FontWeight.normal,
        ),
      ),
    );
  }
}
