// home.dart
import 'package:flutter/material.dart';
import 'package:otwo/widgets/BottomNavigationProvider.dart';
import 'package:provider/provider.dart';
import 'package:otwo/Users/UserStagesPage.dart';
import 'package:otwo/widgets/consts.dart';

class Home extends StatelessWidget {
  final String? userId; // استلام userId هنا
  const Home({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(userId: userId), // تمرير userId هنا
    );
  }
}

class MainScreen extends StatelessWidget {
  final String? userId;

  const MainScreen({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);

    // محتوى الصفحة حسب التبويب المحدد
    Widget getPage(int index) {
      switch (index) {
        case 0:
          return Text('الشخصية'); // صفحة الشخصية
        case 1:
          return Text('الأبطال'); // صفحة الأبطال
        case 2:
          return Text('الإختبارات'); // صفحة الاختبارات
        case 3:
          return UserStagesPage(userId: userId); // صفحة الرئيسية
        default:
          return UserStagesPage(userId: userId);
      }
    }

    return Scaffold(
      body: getPage(bottomNavigationProvider.selectedIndex), // عرض الصفحة حسب التبويب
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy, size: 25),
            label: 'الشخصية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard, size: 25),
            label: 'الأبطال',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz, size: 25),
            label: 'الإختبارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 25),
            label: 'الرئيسية',
          ),
        ],
        currentIndex: bottomNavigationProvider.selectedIndex,
        selectedItemColor: myLightblueColor,
        unselectedItemColor: myBackgroundColor,
        backgroundColor: myWhiteColor,
        onTap: (index) {
          bottomNavigationProvider.updateIndex(index); // تحديث التبويب عبر Provider
        },
        selectedLabelStyle: myBottomBarFont,
        unselectedLabelStyle: myBottomBarFont,
      ),
    );
  }
}
