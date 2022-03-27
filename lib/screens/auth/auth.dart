import 'package:brahmo/screens/auth/login_screen.dart';
import 'package:brahmo/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthScreen extends StatefulWidget {
  static const id = "/auth";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return MainScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
