import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

// Screens
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: PoeageHubApp()));
}

class PoeageHubApp extends StatelessWidget {
  const PoeageHubApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'PoeageHub',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      // First screen when app starts
      home: const SplashScreen(),

      // App navigation routes
      routes: {

        "/login": (context) => const LoginScreen(),

        "/home": (context) => const HomeScreen(),

      },
    );
  }
}