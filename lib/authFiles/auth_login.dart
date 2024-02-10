import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/components/bottomnav.dart';

import 'package:trekking_guide/mainScreens/welcomepage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
 
    FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return BottomNav();
    }
    return WelcomePage();
  }
}
