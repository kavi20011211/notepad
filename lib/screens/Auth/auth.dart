import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/controller_screen.dart';
import 'package:notepad/screens/Auth/login_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return const ControllerScreen();
        }else{
          return const LoginScreen();
        }
      },),
    );
  }
}