import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RecipeBuddyApp());
}

class RecipeBuddyApp extends StatelessWidget {
  const RecipeBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F3EF),
      ),
      home: const SplashScreen(),
    );
  }
}
