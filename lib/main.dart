import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:research_v2/screens/auth/sign-in.dart';
import 'package:research_v2/screens/auth/sign-up.dart';
import 'package:research_v2/screens/home/views/main_screen.dart'; // Import your app widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that widget binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research v2 App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AnimatedSplashScreen(
        splash: 'lib/images/Financial.gif',
        splashIconSize: 2000.0,
        centered: true,
        nextScreen: SignUpPage(),
        backgroundColor: Colors.white,
        duration: 5000,
      ), 
    );
  }
}
