// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:otwo/widgets/AuthProvider.dart';
import 'package:otwo/widgets/BottomNavigationProvider.dart';
import 'package:otwo/widgets/ClassProvider.dart';
import 'package:otwo/widgets/EmailVerificationProvider.dart';
import 'package:otwo/widgets/NavigationProvider.dart';
import 'package:otwo/widgets/PasswordResetProvider.dart';
import 'package:otwo/widgets/StageProvider.dart';
import 'package:otwo/widgets/SubjectProvider.dart';
import 'package:otwo/widgets/UserProfileProvider.dart';
import 'package:otwo/widgets/UserProvider.dart';
import 'package:otwo/widgets/VideoProvider.dart';
import 'package:provider/provider.dart';
import 'package:otwo/Home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (context) => StageProvider()),
        ChangeNotifierProvider(create: (_) => StageProvider()),
        ChangeNotifierProvider(create: (context) => EmailVerificationProvider()), // Add EmailVerificationProvider
        ChangeNotifierProvider(create: (context) => PasswordResetProvider()), // Add PasswordResetProvider // إضافة BottomNavigationProvider
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => SubjectProvider()), 


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}
