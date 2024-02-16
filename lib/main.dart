import 'package:flutter/material.dart';
import 'package:trekking_guide/mainScreens/splashscreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:trekking_guide/utils/custom_colors.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor:
              CustomColors.primaryColor, // Set your desired color here
        ),
      ),
      home: SplashScreen(),
    );
  }
}