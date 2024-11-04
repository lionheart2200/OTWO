import 'package:flutter/material.dart';
import 'package:otwo/widgets/NavigationProvider.dart';
import 'package:provider/provider.dart';
import 'package:otwo/admin/AdminClassesPage.dart';
import 'package:otwo/admin/AdminSubjectsPage.dart';
import 'package:otwo/admin/AdminVideosPage.dart';
import 'package:otwo/admin/AdminStagesPage.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final pages = [
      const AdminStagesPage(),
      const AdminClassesPage(),
      const AdminSubjectsPage(),
      const AdminVideosPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: pages[navigationProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.setPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Manage Stages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Manage Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Manage Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Manage Videos',
          ),
        ],
      ),
    );
  }
}
