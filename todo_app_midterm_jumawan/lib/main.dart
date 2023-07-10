import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      fontFamily: GoogleFonts.mulish().fontFamily,
      ),
      home: EasySplashScreen(
      logo: Image.asset(
          'assets/images/logo.png'),
      title: const Text(
        "Todo App",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey,
      showLoader: true,
      loadingText:const Text("Created by: Joseph Aaron Jumawan"),
      navigator:const AuthenticationScreen(),
      durationInSeconds: 3,
    )
    );
  }
}
