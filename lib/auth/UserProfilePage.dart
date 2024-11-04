import 'package:flutter/material.dart';
import 'package:otwo/widgets/UserProfileProvider.dart';
import 'package:provider/provider.dart';
import 'package:otwo/HomePage.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم المستخدم: ${userProfileProvider.username}', style: const TextStyle(fontSize: 18)),
            Text('رقم الهاتف: ${userProfileProvider.phoneNumber}', style: const TextStyle(fontSize: 18)),
            Text('البريد الإلكتروني: ${userProfileProvider.email}', style: const TextStyle(fontSize: 18)),
            Text('عدد النقاط: ${userProfileProvider.score}', style: const TextStyle(fontSize: 18)),
            Text('ترتيبك: ${userProfileProvider.rank}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'تحديث اسم المستخدم'),
              onChanged: (value) {
                userProfileProvider.updateProfile(value, userProfileProvider.phoneNumber);
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'تحديث رقم الهاتف'),
              onChanged: (value) {
                userProfileProvider.updateProfile(userProfileProvider.username, value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProfileProvider.updateProfile(
                  userProfileProvider.username,
                  userProfileProvider.phoneNumber,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              child: const Text('تحديث الملف الشخصي'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text("admin"),
            ),
          ],
        ),
      ),
    );
  }
}
